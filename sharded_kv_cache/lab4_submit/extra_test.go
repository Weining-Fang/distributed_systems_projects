package kvtest

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"time"
	"cs426.yale.edu/lab4/kv"
	"fmt"
)

// Like previous labs, you must write some tests on your own.
// Add your test cases in this file and submit them as extra_test.go.
// You must add at least 5 test cases, though you can add as many as you like.
//
// You can use any type of test already used in this lab: server
// tests, client tests, or integration tests.
//
// You can also write unit tests of any utility functions you have in utils.go
//
// Tests are run from an external package, so you are testing the public API
// only. You can make methods public (e.g. utils) by making them Capitalized.

// func TestYourTest1(t *testing.T) {
// 	assert.True(t, true)
// }
func TestServerSingleShardMoveWithCopy2(t *testing.T) {
	// Similar to above, but actually tests shard copying from n1 to n2.
	// A single shard is assigned to n1, one key written, then we add the
	// shard to n2. At this point n2 should copy data from its peer n1.
	//
	// We then delete the shard from n1, so n2 is the sole owner, and ensure
	// that n2 has the data originally written to n1.
	setup := MakeTestSetup(
		kv.ShardMapState{
			NumShards: 1,
			Nodes:     makeNodeInfos(3),
			ShardsToNodes: map[int][]string{
				1: {"n1"},
			},
		},
	)

	// n1 hosts the shard, so we should be able to set data
	err := setup.NodeSet("n1", "abc", "123", 10*time.Second)
	assert.Nil(t, err)

	// Add shard 1 to n2
	setup.UpdateShardMapping(map[int][]string{
		1: {"n1", "n2"},
	})
	// Remove shard 1 from n1
	setup.UpdateShardMapping(map[int][]string{
		1: {"n2"},
	})

	_, _, err = setup.NodeGet("n1", "abc")
	// shard no longer mapped, so should error
	assertShardNotAssigned(t, err)

	// should be assigned to n2 now and data should've
	// been copied over from n1
	val, wasFound, err := setup.NodeGet("n2", "abc")
	assert.Nil(t, err)
	assert.True(t, wasFound)
	assert.Equal(t, "123", val)

	// Add shard 1 to n2
	setup.UpdateShardMapping(map[int][]string{
		1: {"n2", "n3"},
	})

	// Now move shard 1 to n3
	setup.UpdateShardMapping(map[int][]string{
		1: {"n3"},
	})

	// n2 should no longer have the shard
	_, _, err = setup.NodeGet("n2", "abc")
	assertShardNotAssigned(t, err)

	// n3 should have the data
	val, wasFound, err = setup.NodeGet("n3", "abc")
	assert.Nil(t, err)
	assert.True(t, wasFound)
	assert.Equal(t, "123", val)

	setup.Shutdown()
	
}

func TestServerMultiShardMoveWithCopy2(t *testing.T) {
	// Expands on the fundamentals of SingleShardMoveWithCopy, but
	// does a shard swap between two nodes. Here we generate 100 random
	// keys, and attempt to assign them all to both nodes. Half of the
	// requests should fail (given the shard is not mapped to that node),
	// but we record where the key was mapped originally. After the shard
	// swap, the keys should flip nodes.
	//
	// Starts with n1: {1,2,3,4,5} and n2: {6,7,8,9,10}
	setup := MakeTestSetup(MakeTwoNodeMultiShard()) // MakeFourNodesWithFiveShards

	keys := RandomKeys(100, 10)
	keysToOriginalNode := make(map[string]string)
	for _, key := range keys {
		// Try setting key on `n1` -- it should either succeed
		// if they key maps to shards 1-5 (we don't know in this case
		// because we don't control your sharding function), or it
		// should fail if it maps to shards 6-10.
		err := setup.NodeSet("n1", key, "123", 10*time.Second)
		if err == nil {
			keysToOriginalNode[key] = "n1"
		} else {
			assertShardNotAssigned(t, err)

			// If the request failed, it should succeed on n2 which
			// hosts the remaining shards
			err = setup.NodeSet("n2", key, "123", 10*time.Second)
			assert.Nil(t, err)
			keysToOriginalNode[key] = "n2"
		}
	}

	// Start the swap by adding all shards to both nodes,
	// allowing them to copy from each other
	setup.UpdateShardMapping(map[int][]string{
		1:  {"n1", "n2"},
		2:  {"n1", "n2"},
		3:  {"n1", "n2"},
		4:  {"n1", "n2"},
		5:  {"n1", "n2"},
		6:  {"n1", "n2"},
		7:  {"n1", "n2"},
		8:  {"n1", "n2"},
		9:  {"n1", "n2"},
		10: {"n1", "n2"},
	})
	// Now remove the duplication, doing the full swap
	setup.UpdateShardMapping(map[int][]string{
		1:  {"n2"},
		2:  {"n2"},
		3:  {"n2"},
		4:  {"n2"},
		5:  {"n2"},
		6:  {"n1"},
		7:  {"n1"},
		8:  {"n1"},
		9:  {"n1"},
		10: {"n1"},
	})

	for _, key := range keys {
		var newNode string
		if keysToOriginalNode[key] == "n1" {
			newNode = "n2"
		} else {
			newNode = "n1"
		}

		// Key should no longer exist on the original node after the swap
		_, _, err := setup.NodeGet(keysToOriginalNode[key], key)
		assertShardNotAssigned(t, err)

		// But it should exist on the new node
		val, wasFound, err := setup.NodeGet(newNode, key)
		assert.Nil(t, err)
		assert.True(t, wasFound)
		assert.Equal(t, "123", val)
	}

	// Start the swap by adding all shards to both nodes,
	// allowing them to copy from each other
	setup.UpdateShardMapping(map[int][]string{
		1:  {"n1", "n2"},
		2:  {"n1", "n2"},
		3:  {"n1", "n2"},
		4:  {"n1", "n2"},
		5:  {"n1", "n2"},
		6:  {"n1", "n2"},
		7:  {"n1", "n2"},
		8:  {"n1", "n2"},
		9:  {"n1", "n2"},
		10: {"n1", "n2"},
	})
	// Now remove the duplication, doing the full swap
	setup.UpdateShardMapping(map[int][]string{
		1:  {"n1"},
		2:  {"n1"},
		3:  {"n1"},
		4:  {"n1"},
		5:  {"n1"},
		6:  {"n2"},
		7:  {"n2"},
		8:  {"n2"},
		9:  {"n2"},
		10: {"n2"},
	})

	for _, key := range keys {
		var newNode string
		if keysToOriginalNode[key] == "n1" {
			newNode = "n2"
		} else {
			newNode = "n1"
		}

		// Key should no longer exist on the original node after the swap
		_, _, err := setup.NodeGet(newNode, key)
		assertShardNotAssigned(t, err)

		// But it should exist on the new node
		val, wasFound, err := setup.NodeGet(keysToOriginalNode[key], key)
		assert.Nil(t, err)
		assert.True(t, wasFound)
		assert.Equal(t, "123", val)
	}

	setup.Shutdown()
}

func TestServerRestartShardCopy2(t *testing.T) {
	// Tests that your server copies data at startup as well, not just
	// shard movements after it is running.
	//
	// We have two nodes with a single shard, and we shutdown and restart n2
	// and it should copy data from n1.
	setup := MakeTestSetup(MakeTwoNodeBothAssignedSingleShard())

	err := setup.NodeSet("n1", "abc", "123", 100*time.Second)
	assert.Nil(t, err)
	err = setup.NodeSet("n2", "abc", "123", 100*time.Second)
	assert.Nil(t, err)

	// Value should exist on n1 and n2
	val, wasFound, err := setup.NodeGet("n1", "abc")
	assert.Nil(t, err)
	assert.True(t, wasFound)
	assert.Equal(t, "123", val)

	val, wasFound, err = setup.NodeGet("n2", "abc")
	assert.Nil(t, err)
	assert.True(t, wasFound)
	assert.Equal(t, "123", val)

	setup.nodes["n2"].Shutdown()
	setup.nodes["n2"] = kv.MakeKvServer("n2", setup.shardMap, &setup.clientPool)

	// n2 should copy the data from n1 on restart
	val, wasFound, err = setup.NodeGet("n2", "abc")
	assert.Nil(t, err)
	assert.True(t, wasFound)
	assert.Equal(t, "123", val)

	setup.nodes["n1"].Shutdown()
	setup.nodes["n1"] = kv.MakeKvServer("n1", setup.shardMap, &setup.clientPool)
	val, wasFound, err = setup.NodeGet("n1", "abc")
	assert.Nil(t, err)
	assert.True(t, wasFound)
	assert.Equal(t, "123", val)


	setup.Shutdown()
}

func TestClientMultiNodeMultiShardSwap2(t *testing.T) {
	// Setup with 3 nodes and 6 shards
	setup := MakeTestSetupWithoutServers(
		kv.ShardMapState{
			NumShards: 6,
			Nodes:     makeNodeInfos(3),
			ShardsToNodes: map[int][]string{
				1: {"n1"},
				2: {"n1"},
				3: {"n2"},
				4: {"n2"},
				5: {"n3"},
				6: {"n3"},
			},
		},
	)

	keys := RandomKeys(600, 5)
	setup.clientPool.OverrideSetResponse("n1")
	setup.clientPool.OverrideSetResponse("n2")
	setup.clientPool.OverrideSetResponse("n3")

	keysToOriginalNodes := make(map[string]string)
	for _, key := range keys {
		err := setup.Set(key, "v", 1*time.Second)
		assert.Nil(t, err)
		if setup.clientPool.GetRequestsSent("n1") > 0 {
			keysToOriginalNodes[key] = "n1"
		} else if setup.clientPool.GetRequestsSent("n2") > 0 {
			keysToOriginalNodes[key] = "n2"
		} else {
			keysToOriginalNodes[key] = "n3"
		}
		setup.clientPool.ClearRequestsSent("n1")
		setup.clientPool.ClearRequestsSent("n2")
		setup.clientPool.ClearRequestsSent("n3")
	}

	// Swap shards among nodes
	setup.UpdateShardMapping(map[int][]string{
		1: {"n2"},
		2: {"n3"},
		3: {"n1"},
		4: {"n3"},
		5: {"n1"},
		6: {"n2"},
	})

	setup.clientPool.OverrideGetResponse("n1", "from n1", true)
	setup.clientPool.OverrideGetResponse("n2", "from n2", true)
	setup.clientPool.OverrideGetResponse("n3", "from n3", true)

	for _, key := range keys {
		val, wasFound, err := setup.Get(key)
		assert.Nil(t, err)
		assert.True(t, wasFound)

		// Determine expected node after shard swap
		shardID := kv.GetShardForKey(key, 6)
		var expectedNode string
		switch shardID {
		case 1:
			expectedNode = "n2"
		case 2:
			expectedNode = "n3"
		case 3:
			expectedNode = "n1"
		case 4:
			expectedNode = "n3"
		case 5:
			expectedNode = "n1"
		case 6:
			expectedNode = "n2"
		}

		expectedValue := fmt.Sprintf("from %s", expectedNode)
		assert.Equal(t, expectedValue, val)
	}
}

func TestClientMultiNodeMultiShard3(t *testing.T) {
	// Tests actual sharding logic -- if we send
	// a Set(key1), then a Get(key1) should go to the same
	// shard.
	//
	// This setup has two nodes, each with 5 different shards, and they don't
	// have any shards in common. If a Set request went to node1, then
	// the Get request must also go to node1 because it is the host of that
	// shard exclusively.
	setup := MakeTestSetupWithoutServers(MakeTwoNodeMultiShard())

	keys := RandomKeys(1000, 5)
	setup.clientPool.OverrideSetResponse("n1")
	setup.clientPool.OverrideSetResponse("n2")

	keysToNodes := make(map[string]string)
	for _, key := range keys {
		err := setup.Set(key, "v", 1*time.Second)
		assert.Nil(t, err)

		// Keep track of where Set requests went to
		if setup.clientPool.GetRequestsSent("n1") > 0 {
			keysToNodes[key] = "n1"
		} else {
			keysToNodes[key] = "n2"
		}

		// Reset the counters to make it easier to keep track
		setup.clientPool.ClearRequestsSent("n1")
		setup.clientPool.ClearRequestsSent("n2")
	}

	setup.clientPool.OverrideGetResponse("n1", "from n1", true)
	setup.clientPool.OverrideGetResponse("n2", "from n2", true)
	for _, key := range keys {
		val, wasFound, err := setup.Get(key)
		assert.Nil(t, err)
		assert.True(t, wasFound)
		if keysToNodes[key] == "n1" {
			assert.Equal(t, "from n1", val)
		} else {
			assert.Equal(t, "from n2", val)
		}
	}
}

func TestClientMultiNodeMultiShard2(t *testing.T) {
	// Setup with 4 nodes and 8 shards
	setup := MakeTestSetupWithoutServers(
		kv.ShardMapState{
			NumShards: 8,
			Nodes:     makeNodeInfos(4),
			ShardsToNodes: map[int][]string{
				1: {"n1"}, 2: {"n1"},
				3: {"n2"}, 4: {"n2"},
				5: {"n3"}, 6: {"n3"},
				7: {"n4"}, 8: {"n4"},
			},
		},
	)

	keys := RandomKeys(800, 5)
	setup.clientPool.OverrideSetResponse("n1")
	setup.clientPool.OverrideSetResponse("n2")
	setup.clientPool.OverrideSetResponse("n3")
	setup.clientPool.OverrideSetResponse("n4")

	keysToNodes := make(map[string]string)
	for _, key := range keys {
		err := setup.Set(key, "v", 1*time.Second)
		assert.Nil(t, err)

		// Identify which node the Set request went to
		for i := 1; i <= 4; i++ {
			nodeName := fmt.Sprintf("n%d", i)
			if setup.clientPool.GetRequestsSent(nodeName) > 0 {
				keysToNodes[key] = nodeName
				break
			}
		}

		// Reset request counts
		setup.clientPool.ClearRequestsSent("n1")
		setup.clientPool.ClearRequestsSent("n2")
		setup.clientPool.ClearRequestsSent("n3")
		setup.clientPool.ClearRequestsSent("n4")
	}

	// Override Get responses
	setup.clientPool.OverrideGetResponse("n1", "from n1", true)
	setup.clientPool.OverrideGetResponse("n2", "from n2", true)
	setup.clientPool.OverrideGetResponse("n3", "from n3", true)
	setup.clientPool.OverrideGetResponse("n4", "from n4", true)

	// Verify that Get requests go to the correct node
	for _, key := range keys {
		val, wasFound, err := setup.Get(key)
		assert.Nil(t, err)
		assert.True(t, wasFound)
		expectedValue := fmt.Sprintf("from %s", keysToNodes[key])
		assert.Equal(t, expectedValue, val)
	}
}
