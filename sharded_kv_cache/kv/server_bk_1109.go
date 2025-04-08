package kv

import (
	"context"

	"cs426.yale.edu/lab4/kv/proto"
	"github.com/sirupsen/logrus"
	"sync"
	"time"
	"google.golang.org/grpc/codes" 
	"google.golang.org/grpc/status" 
)

type ValueWithTtl struct {
	Value			string
	TimeExpire		time.Time

}

type Shard struct{
	Data		map[string]ValueWithTtl
}

type KvServerImpl struct {
	proto.UnimplementedKvServer
	nodeName string

	shardMap   		*ShardMap
	listener   		*ShardMapListener
	clientPool 		ClientPool
	shutdown   		chan struct{}
	shardData  		map[int] *Shard
	shardLocks		map[int]*sync.RWMutex
	dataExpired		[]string 
	hostedShards	[]int
	mu				sync.Mutex
	node_inds 		map[int]int
}

func (server *KvServerImpl) GetUsableClient(nodes []string) (proto.KvClient, error, string) {
	for _, node := range nodes {
		kvClient, err1 := server.clientPool.GetClient(node)
		if err1 == nil {
			// fmt.Printf("GetUsableClient got client from node %v\n", node)
			return kvClient, nil, node
		}
	}
	
	return nil, status.Errorf(codes.NotFound, "No available nodes"), ""
}

func (server *KvServerImpl) copyShardData(shard_id int) error {
	var err error 
	nodes := server.shardMap.NodesForShard(shard_id) // []string

	if len(nodes) == 0 || (len(nodes) == 1 && nodes[0] == server.nodeName) {
		return status.Errorf(codes.NotFound, "No nodes host the shard %v", shard_id)
	}

	server.mu.Lock()
	ind := server.node_inds[shard_id] % len(nodes)
	server.node_inds[shard_id] = ind + 1
	server.mu.Unlock()

	new_node := nodes[ind]
	kvClient, err1 := server.clientPool.GetClient(nodes[ind])
	if err1 != nil {
		kvClient, err1, new_node = kv.GetUsableClient(nodes)
		if err1 != nil {
			return err1
		}
	}

	// fmt.Printf("Node %v is to send getRequest for key %v\n", new_node, key)
	getResponse, err2 := kvClient.Get(ctx, &proto.GetRequest{Key: key})
	


}

func (server *KvServerImpl) handleShardMapUpdate() {
	// TODO: Part C
	server.mu.Lock()
	defer server.mu.Unlock()

	included := make(map[int]bool)
	for _, shard_id := range server.hostedShards {
		included[shard_id] = false
	}

	newShards := server.shardMap.ShardsForNode(server.nodeName)

	for _, s := range newShards {
		if !contains(s, server.hostedShards) {
			server.shardData[s] = &Shard{Data: make(map[string]ValueWithTtl),}
			server.shardLocks[s] = &sync.RWMutex{}

		} else {
			included[s] = true
		}
	}

	// nodes := server.shardMap.Nodes()
	// for _, node := range nodes {
	// 	shards := server.shardMap.ShardsForNode(node.Address) //[]int
	// 	for _, s := range shards {
	// 		_, contains := server.shardData[s]
	// 		if contains == false {
	// 			server.shardData[s] = &Shard{Data: make(map[string]ValueWithTtl),}
	// 			server.shardLocks[s] = &sync.RWMutex{}
	// 		} else {
	// 			included[s] = true
	// 		}
	// 	}
	// }
	
	for k := range included {
		if included[k] == false {
			server.shardLocks[k].Lock()
			server.shardData[k] = &Shard{Data: make(map[string]ValueWithTtl),}
			server.shardLocks[k].Unlock()
			// delete(server.shardData, k)
			delete(server.shardLocks, k)
		}
	}
	server.hostedShards = newShards
}

func (server *KvServerImpl) shardMapListenLoop() {
	listener := server.listener.UpdateChannel()
	for {
		select {
		case <-server.shutdown:
			return
		case <-listener:
			server.handleShardMapUpdate()
		}
	}
}

func (server *KvServerImpl) cleanExpiredKVs() {
	for {
		select {
		case <- server.shutdown: 
			return
		default:
			time.Sleep(1 * time.Second)
			for ind, shard := range server.shardData {
				server.shardLocks[ind].Lock()
				for k, vttl := range shard.Data {
					if vttl.TimeExpire.Before(time.Now()) {
						delete(server.shardData[ind].Data, k)
						// server.Delete(context.Background(), &proto.DeleteRequest{Key: k})
					}
				}
				server.shardLocks[ind].Unlock()
			}
			
		}
	}
	

}

func MakeKvServer(nodeName string, shardMap *ShardMap, clientPool ClientPool) *KvServerImpl {
	listener := shardMap.MakeListener()
	server := KvServerImpl{
		nodeName:   nodeName,
		shardMap:   shardMap,
		listener:   &listener,
		clientPool: clientPool,
		shutdown:   make(chan struct{}),
		shardData:  make(map[int]*Shard),
		shardLocks: make(map[int]*sync.RWMutex),
		// dataExpired: make([]string, 0),
		hostedShards: shardMap.ShardsForNode(nodeName),

	}
	for i:= 1; i <= shardMap.NumShards(); i++ {
		server.shardData[i] = &Shard{Data: make(map[string]ValueWithTtl),}
		server.shardLocks[i] = &sync.RWMutex{}
		server.node_inds[i] = 0
	}

	go server.shardMapListenLoop()
	go server.cleanExpiredKVs()
	server.handleShardMapUpdate()
	return &server
}

func (server *KvServerImpl) Shutdown() {
	server.shutdown <- struct{}{}
	server.listener.Close()
}

func (server *KvServerImpl) Get(
	ctx context.Context,
	request *proto.GetRequest, 
) (*proto.GetResponse, error) {
	// Trace-level logging for node receiving this request (enable by running with -log-level=trace),
	// feel free to use Trace() or Debug() logging in your code to help debug tests later without
	// cluttering logs by default. See the logging section of the spec.
	logrus.WithFields(
		logrus.Fields{"node": server.nodeName, "key": request.Key},
	).Trace("node received Get() request")
	// panic("TODO: Part A")

	key := request.GetKey()
	if key == "" {
		return nil, status.Errorf(codes.InvalidArgument, "key cannot be empty in Get()")
	}
	shard_ind := GetShardForKey(key, server.GetNumShards())

	if !contains(shard_ind, server.hostedShards) {
		return nil, status.Errorf(codes.NotFound, "shard %v is not hosted by server %v: %v", shard_ind, server.nodeName, server.hostedShards)
	}

	server.shardLocks[shard_ind].RLock()
	defer server.shardLocks[shard_ind].RUnlock()
	val_with_ttl, exists := server.shardData[shard_ind].Data[key]

	if !exists || val_with_ttl.TimeExpire.Before(time.Now()) {
		// server.mu.Lock()
		// defer server.mu.Unlock()
		// server.dataExpired = append(server.dataExpired, key)
		return &proto.GetResponse{Value: "", WasFound: false}, nil
	} else {
		return &proto.GetResponse{Value: val_with_ttl.Value, WasFound: true}, nil
	}

}

func (server *KvServerImpl) GetNumShards() int {
	// server.mu.Lock()
	// defer server.mu.Unlock()
	return server.shardMap.NumShards()
}


func (server *KvServerImpl) Set(
	ctx context.Context,
	request *proto.SetRequest,
) (*proto.SetResponse, error) {
	logrus.WithFields(
		logrus.Fields{"node": server.nodeName, "key": request.Key},
	).Trace("node received Set() request")
	// panic("TODO: Part A")
	key := request.GetKey()
	if key == "" {
		return nil, status.Errorf(codes.InvalidArgument, "key cannot be empty in Set()")
	}
	shard_ind := GetShardForKey(key, server.GetNumShards())

	if !contains(shard_ind, server.hostedShards) {
		return nil, status.Errorf(codes.NotFound, "shard %v is not hosted by server %v: %v", shard_ind, server.nodeName, server.hostedShards)
	}

	val_with_ttl := ValueWithTtl {
		Value: request.GetValue(),
		TimeExpire: time.Now().Add(time.Duration(request.GetTtlMs()) * time.Millisecond),
	} 
	// acquire a write lock
	server.shardLocks[shard_ind].Lock()
	defer server.shardLocks[shard_ind].Unlock()
	server.shardData[shard_ind].Data[key] = val_with_ttl
	
	
	return &proto.SetResponse{}, nil
}

func (server *KvServerImpl) Delete(
	ctx context.Context,
	request *proto.DeleteRequest,
) (*proto.DeleteResponse, error) {
	logrus.WithFields(
		logrus.Fields{"node": server.nodeName, "key": request.Key},
	).Trace("node received Delete() request")
	// panic("TODO: Part A")
	key := request.GetKey()
	if key == "" {
		return nil, status.Errorf(codes.InvalidArgument, "key cannot be empty in Delete()")
	}
	shard_ind := GetShardForKey(key, server.GetNumShards())

	if !contains(shard_ind, server.hostedShards) {
		return nil, status.Errorf(codes.NotFound, "shard %v is not hosted by server %v: %v", shard_ind, server.nodeName, server.hostedShards)
	}

	server.shardLocks[shard_ind].Lock()
	defer server.shardLocks[shard_ind].Unlock()
	delete(server.shardData[shard_ind].Data, key)
	return &proto.DeleteResponse{}, nil

}

func (server *KvServerImpl) GetShardContents(
	ctx context.Context,
	request *proto.GetShardContentsRequest,
) (*proto.GetShardContentsResponse, error) {
	// panic("TODO: Part C")

	shard_id := request.GetShard()

	if !contains(shard_id, server.hostedShards) {
		return nil, status.Errorf(codes.NotFound, "shard %v is not hosted by server %v: %v", shard_id, server.nodeName, server.hostedShards)
	}

	getShardValues := make([]*proto.GetShardValue)

	for _, sid := range server.hostedShards {
		if sid == shard_id {
			server.shardLocks[sid].Rlock()
			defer server.shardLocks[sid].RUnlock()

			shardData := server.shardData[sid]
			for k, vttl := shardData.Data {
				get_shard_val := &proto.GetShardValue{
					Key: k,
					Value: vttl.Value,
					TtlMsRemaining: vttl.TimeExpire.Sub(time.Now).Milliseconds()
				}
				getShardValues = append(getShardValues, get_shard_val)
			}
		}
	}
	return &proto.GetShardContentsResponse{Values: getShardValues}, nil
}
