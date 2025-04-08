package kv

import (
	"context"
	"time"

	"github.com/sirupsen/logrus"

	"fmt"
	"sync"

	"cs426.yale.edu/lab4/kv/proto"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type Kv struct {
	shardMap   *ShardMap
	clientPool ClientPool

	// Add any client-side state you want here
	mu        sync.Mutex
	node_inds map[int]int
}

func MakeKv(shardMap *ShardMap, clientPool ClientPool) *Kv {
	kv := &Kv{
		shardMap:   shardMap,
		clientPool: clientPool,
		node_inds:  make(map[int]int),
	}
	// Add any initialization logic
	for i := 1; i <= shardMap.NumShards(); i++ {
		kv.node_inds[i] = 0
	}
	return kv
}

func (kv *Kv) GetUsableClient(nodes []string) (proto.KvClient, error, string) {
	for _, node := range nodes {
		// if repeat == false && node == self_node {
		// 	continue
		// }
		kvClient, err1 := kv.clientPool.GetClient(node)
		if err1 == nil {
			// fmt.Printf("GetUsableClient got client from node %v\n", node)
			return kvClient, nil, node
		}
	}

	return nil, status.Errorf(codes.NotFound, "No available nodes"), ""
}

func removeNode(slice []string, node string) []string {
	// fmt.Printf("slice before remove: %v, node to remove:%v\n", slice, node)
	for i, v := range slice {
		if node == v {
			ret := make([]string, 0)
			for j, n := range slice {
				if j != i {
					ret = append(ret, n)
				}
			}
			// fmt.Printf("slice after remove: %v\n", ret)
			return ret
		}
	}
	// fmt.Printf("slice after remove: %v\n", slice)
	return slice
}

func (kv *Kv) Get(ctx context.Context, key string) (string, bool, error) {
	// Trace-level logging -- you can remove or use to help debug in your tests
	// with `-log-level=trace`. See the logging section of the spec.
	logrus.WithFields(
		logrus.Fields{"key": key},
	).Trace("client sending Get() request")
	// panic("TODO: Part B")

	shard_id := GetShardForKey(key, kv.shardMap.NumShards())
	nodes := kv.shardMap.NodesForShard(shard_id) // []string

	if len(nodes) == 0 {
		return "", false, status.Errorf(codes.NotFound, "No nodes host the shard %v", shard_id)
	}

	kv.mu.Lock()
	ind := kv.node_inds[shard_id] % len(nodes)
	kv.node_inds[shard_id] = ind + 1
	kv.mu.Unlock()

	new_node := nodes[ind]
	kvClient, err1 := kv.clientPool.GetClient(nodes[ind])
	if err1 != nil {
		kvClient, err1, new_node = kv.GetUsableClient(nodes)
		if err1 != nil {
			return "", false, err1
		}
	}

	// fmt.Printf("Node %v is to send getRequest for key %v\n", new_node, key)
	getResponse, err2 := kvClient.Get(ctx, &proto.GetRequest{Key: key})

	if err2 != nil {

		// node_used := make(map[string]bool)
		// for _, n := range nodes {
		// 	if n == new_node {
		// 		node_used[n] = true
		// 	} else {
		// 		node_used[n] = false
		// 	}
		// }

		reduced_nodes := removeNode(nodes, new_node)
		// num_nodes_used := 1

		// for num_nodes_used < len(nodes) {
		for len(reduced_nodes) > 0 {
			kvClient, err1, new_node = kv.GetUsableClient(reduced_nodes)

			if err1 != nil {
				return "", false, err1
			}

			// fmt.Printf("got new node %v\n", new_node)

			getResponse, err2 = kvClient.Get(ctx, &proto.GetRequest{Key: key})
			if err2 == nil {
				return getResponse.GetValue(), getResponse.GetWasFound(), nil
			}

			// node_used[new_node] = true
			reduced_nodes = removeNode(reduced_nodes, new_node)

			// num_nodes_used = 1
			// for _, used := range node_used {
			// 	if used {
			// 		num_nodes_used++
			// 	}
			// }
			// fmt.Printf("num of nodes available: %v\n", len(reduced_nodes))

		}

		return "", false, err2
	} else {
		// fmt.Printf("node %v successfully get value for key %v\n", new_node, key)
		fmt.Printf("")
		return getResponse.GetValue(), getResponse.GetWasFound(), err2
	}

}

func (kv *Kv) Set(ctx context.Context, key string, value string, ttl time.Duration) error {
	logrus.WithFields(
		logrus.Fields{"key": key},
	).Trace("client sending Set() request")
	// panic("TODO: Part B")

	shard_id := GetShardForKey(key, kv.shardMap.NumShards())
	nodes := kv.shardMap.NodesForShard(shard_id) // []string

	if len(nodes) == 0 {
		return status.Errorf(codes.NotFound, "No nodes host the shard %v", shard_id)
	}

	var mu sync.Mutex
	var err error
	var wg sync.WaitGroup
	for _, n := range nodes {
		wg.Add(1)
		go func(node string) {
			defer wg.Done()
			kvClient, err1 := kv.clientPool.GetClient(node)
			if err1 != nil {
				mu.Lock()
				err = err1
				mu.Unlock()
				return
			}

			_, err2 := kvClient.Set(ctx, &proto.SetRequest{Key: key, Value: value, TtlMs: ttl.Milliseconds()})
			if err2 != nil {
				mu.Lock()
				err = err2
				mu.Unlock()
			}
		}(n)
	}
	wg.Wait()

	return err

}

func (kv *Kv) Delete(ctx context.Context, key string) error {
	logrus.WithFields(
		logrus.Fields{"key": key},
	).Trace("client sending Delete() request")
	// panic("TODO: Part B")
	shard_id := GetShardForKey(key, kv.shardMap.NumShards())
	nodes := kv.shardMap.NodesForShard(shard_id) // []string

	if len(nodes) == 0 {
		return status.Errorf(codes.NotFound, "No nodes host the shard %v", shard_id)
	}

	var mu sync.Mutex
	var err error
	var wg sync.WaitGroup
	for _, n := range nodes {
		wg.Add(1)
		go func(node string) {
			defer wg.Done()
			kvClient, err1 := kv.clientPool.GetClient(node)
			if err1 != nil {
				mu.Lock()
				err = err1
				mu.Unlock()
				return
			}

			_, err2 := kvClient.Delete(ctx, &proto.DeleteRequest{Key: key})
			if err2 != nil {
				mu.Lock()
				err = err2
				mu.Unlock()
			}
		}(n)
	}
	wg.Wait()

	return err
}
