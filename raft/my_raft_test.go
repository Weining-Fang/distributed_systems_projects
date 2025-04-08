package raft

//
// Raft tests.
//
// we will use the original test_test.go to test your code for grading.
// so, while you can modify this code to help you debug, please
// test with the original before submitting.
//

import (
	// "fmt"
	"math/rand"
	// "sync"
	// "sync/atomic"
	"testing"
	"time"
)

// The tester generously allows solutions to complete elections in one second
// (much more than the paper's range of timeouts).
func TestReElection23A(t *testing.T) {
	servers := 5
	cfg := make_config(t, servers, false, false)
	defer cfg.cleanup()

	cfg.begin("Self Test (3A): election after network failure")

	leader1 := cfg.checkOneLeader()

	// if the leader disconnects, a new one should be elected.
	cfg.disconnect(leader1)
	cfg.checkOneLeader()

	// if the old leader rejoins, that shouldn't
	// disturb the new leader.
	cfg.connect(leader1)
	time.Sleep(RaftElectionTimeout/2) // Short buffer before the next check.
	leader2 := cfg.checkOneLeader()

	// if there's no quorum, no leader should
	// be elected.
	cfg.disconnect((leader2 + 1) % servers)
	cfg.disconnect((leader2 + 2) % servers)
	cfg.disconnect(leader2)
	time.Sleep(2 * RaftElectionTimeout)
	cfg.checkNoLeader()

	// if a quorum arises, it should elect a leader.
	cfg.connect((leader2 + 1) % servers)
	time.Sleep(RaftElectionTimeout/2) // Short buffer before the next check.
	cfg.checkOneLeader()

	// re-join of last node shouldn't prevent leader from existing.
	cfg.connect(leader2)
	cfg.connect((leader2 + 2) % servers)
	time.Sleep(RaftElectionTimeout/2) // Short buffer before the next check.
	cfg.checkOneLeader()

	cfg.end()
}

func TestManyElections23A(t *testing.T) {
	servers := 5
	cfg := make_config(t, servers, false, false)
	defer cfg.cleanup()

	cfg.begin("Self Test (3A): multiple elections")

	cfg.checkOneLeader()

	iters := 10
	for ii := 1; ii < iters; ii++ {
		// disconnect 2 nodes
		i1 := rand.Int() % servers
		i2 := rand.Int() % servers
		// i3 := rand.Int() % servers
		cfg.disconnect(i1)
		cfg.disconnect(i2)
		// cfg.disconnect(i3)
		time.Sleep(RaftElectionTimeout) // Short buffer before the next check.

		// either the current leader should still be alive,
		// or the remaining four should elect a new one.
		cfg.checkOneLeader()

		cfg.connect(i1)
		cfg.connect(i2)
		// cfg.connect(i3)
		time.Sleep(RaftElectionTimeout) // Short buffer before the next check.
	}

	cfg.checkOneLeader()

	cfg.end()
}

func TestFailAgree23B(t *testing.T) {
	servers := 5 //3
	cfg := make_config(t, servers, false, false)
	defer cfg.cleanup()

	cfg.begin("Self Test (3B): agreement despite follower disconnection")

	cfg.one(101, servers, false)

	// disconnect 2 followers from the network.
	leader := cfg.checkOneLeader()
	cfg.disconnect((leader + 1) % servers)
	cfg.disconnect((leader + 2) % servers)

	// the leader and remaining followers should be
	// able to agree despite the disconnected follower.
	cfg.one(102, servers-2, false)
	cfg.one(103, servers-2, false)
	time.Sleep(RaftElectionTimeout)
	cfg.one(104, servers-2, false)
	cfg.one(105, servers-2, false)

	// re-connect
	cfg.connect((leader + 1) % servers)
	cfg.connect((leader + 2) % servers)

	// the full set of servers should preserve
	// previous agreements, and be able to agree
	// on new commands.
	cfg.one(106, servers, true)
	time.Sleep(RaftElectionTimeout)
	cfg.one(107, servers, true)

	cfg.end()
}

func TestRejoin23B(t *testing.T) {
	servers := 5 //3
	cfg := make_config(t, servers, false, false)
	defer cfg.cleanup()

	cfg.begin("Self Test (3B): rejoin of partitioned leader")

	cfg.one(101, servers, true)

	// leader network failure
	leader1 := cfg.checkOneLeader()
	cfg.disconnect(leader1)

	// make old leader try to agree on some entries
	cfg.rafts[leader1].Start(102)
	cfg.rafts[leader1].Start(103)
	cfg.rafts[leader1].Start(104)

	// new leader commits, also for index=2
	cfg.one(103, servers - 1, true)

	// new leader network failure
	leader2 := cfg.checkOneLeader()
	cfg.disconnect(leader2)

	// old leader connected again
	cfg.connect(leader1)

	cfg.one(104, servers - 1, true)

	// all together now
	cfg.connect(leader2)

	cfg.one(105, servers, true)

	cfg.end()
}

func TestBackup23B(t *testing.T) {
	servers := 5
	cfg := make_config(t, servers, false, false)
	defer cfg.cleanup()

	cfg.begin("Self Test (3B): leader backs up quickly over incorrect follower logs")

	cfg.one(rand.Int(), servers, true)

	// put leader and one follower in a partition
	leader1 := cfg.checkOneLeader()
	cfg.disconnect((leader1 + 2) % servers)
	cfg.disconnect((leader1 + 3) % servers)
	cfg.disconnect((leader1 + 4) % servers)

	// submit lots of commands that won't commit
	for i := 0; i < 100; i++ {
		cfg.rafts[leader1].Start(rand.Int())
	}

	time.Sleep(RaftElectionTimeout / 2)

	cfg.disconnect((leader1 + 0) % servers)
	cfg.disconnect((leader1 + 1) % servers)

	// allow other partition to recover
	cfg.connect((leader1 + 2) % servers)
	cfg.connect((leader1 + 3) % servers)
	cfg.connect((leader1 + 4) % servers)

	// lots of successful commands to new group.
	for i := 0; i < 100; i++ {
		cfg.one(rand.Int(), 3, true)
	}

	// now another partitioned leader and one follower
	leader2 := cfg.checkOneLeader()
	other := (leader1 + 2) % servers
	if leader2 == other {
		other = (leader2 + 1) % servers
	}
	cfg.disconnect(other)

	// lots more commands that won't commit
	for i := 0; i < 100; i++ {
		cfg.rafts[leader2].Start(rand.Int())
	}

	time.Sleep(RaftElectionTimeout / 2)

	// bring original leader back to life,
	for i := 0; i < servers; i++ {
		cfg.disconnect(i)
	}
	cfg.connect((leader1 + 0) % servers)
	cfg.connect((leader1 + 1) % servers)
	cfg.connect(other)

	// lots of successful commands to new group.
	for i := 0; i < 100; i++ {
		cfg.one(rand.Int(), 3, true)
	}

	// now everyone
	for i := 0; i < servers; i++ {
		cfg.connect(i)
	}
	cfg.one(rand.Int(), servers, true)

	cfg.end()
}


