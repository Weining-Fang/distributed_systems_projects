package kv

import "hash/fnv"

/// This file can be used for any common code you want to define and separate
/// out from server.go or client.go

func GetShardForKey(key string, numShards int) int {
	hasher := fnv.New32()
	hasher.Write([]byte(key))
	return int(hasher.Sum32())%numShards + 1 
}
 
func contains(shardnum int, shardlst []int) bool {
	for _, v := range shardlst {
		if v == shardnum {
			return true
		}
	}
	return false
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