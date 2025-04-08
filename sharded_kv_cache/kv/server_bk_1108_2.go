package kv

import (
	"context"

	"sync"
	"time"

	"cs426.yale.edu/lab4/kv/proto"
	"github.com/sirupsen/logrus"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type ValueWithTtl struct {
	Value      string
	TimeExpire time.Time
}

type Shard struct {
	Data map[string]ValueWithTtl
}

type KvServerImpl struct {
	proto.UnimplementedKvServer
	nodeName string

	shardMap     *ShardMap
	listener     *ShardMapListener
	clientPool   ClientPool
	shutdown     chan struct{}
	shardData    map[int]*Shard
	shardLocks   map[int]*sync.RWMutex
	dataExpired  []string
	hostedShards []int
	mu           sync.Mutex
}

func (server *KvServerImpl) handleShardMapUpdate() {
	// TODO: Part C
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
		case <-server.shutdown:
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
			// server.mu.Lock()
			// dataExpired := server.dataExpired
			// for _, k := range dataExpired {
			// 	// shard_id := GetShardForKey(k, server.shardMap.GetNumShards())
			// 	server.Delete(context.Background(), &proto.DeleteRequest{Key: k})
			// 	// server.dataExpired = server.dataExpired[i+1:]
			// }
			// server.dataExpired = make([]string, 0)
			// server.mu.Unlock()
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
	for i := 1; i <= shardMap.NumShards(); i++ {
		server.shardData[i] = &Shard{Data: make(map[string]ValueWithTtl)}
		server.shardLocks[i] = &sync.RWMutex{}
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

	val_with_ttl := ValueWithTtl{
		Value:      request.GetValue(),
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
	panic("TODO: Part C")
}
