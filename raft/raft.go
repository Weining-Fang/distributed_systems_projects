package raft

//
// this is an outline of the API that raft must expose to
// the service (or tester). see comments below for
// each of these functions for more details.
//
// rf = Make(...)
//   create a new Raft server.
// rf.Start(command interface{}) (index, term, isleader)
//   start agreement on a new log entry
// rf.GetState() (term, isLeader)
//   ask a Raft for its current term, and whether it thinks it is leader
// ApplyMsg
//   each time a new entry is committed to the log, each Raft peer
//   should send an ApplyMsg to the service (or tester)
//   in the same server.
//

import (
	"bytes"
	"sync"
	"sync/atomic"

	"6.824/labgob"
	"6.824/labrpc"

	"time"
	"math/rand"
	"sort"
	// "fmt"
	"log"
)

// Seed the random number generator
var seedOnce sync.Once

//
// as each Raft peer becomes aware that successive log entries are
// committed, the peer should send an ApplyMsg to the service (or
// tester) on the same server, via the applyCh passed to Make(). set
// CommandValid to true to indicate that the ApplyMsg contains a newly
// committed log entry.
//
type ApplyMsg struct {
	CommandValid bool
	Command      interface{}
	CommandIndex int
}

// self: log entry struct 
type LogEntry struct {
	Term         int // term when entry was received by leader (first index is 1)
	Command      interface{}
}

//
// A Go object implementing a single Raft peer.
//
type Raft struct {
	mu        sync.Mutex          // Lock to protect shared access to this peer's state
	peers     []*labrpc.ClientEnd // RPC end points of all peers
	persister *Persister          // Object to hold this peer's persisted state
	me        int                 // this peer's index into peers[]
	dead      int32               // set by Kill()

	// Your data here (3A, 3B, 3C).
	// Look at the paper's Figure 2 for a description of what
	// state a Raft server must maintain.
	currentTerm 		int // latest term server has seen (initialized to 0 on first boot, increases monotonically)
	votedFor   			int // candidateId that received vote in current term (or null if none)
	logEntries  		[]*LogEntry
	commitIndex 		int // index of highest log entry known to be committed (initialized to 0, increases monotonically)
	lastApplied 		int // index of highest log entry applied to state machine (initialized to 0, increases monotonically)
	nextIndex   		[]int // for each server, index of the next log entry to send to that server (initialized to leader last log index + 1)	
	matchIndex  		[]int // for each server, index of highest log entry known to be replicated on server(initialized to 0, increases monotonically)
	applyCh     		chan ApplyMsg
	electionTimeout  	time.Duration // millisecond
	lastHeartbeat  		time.Time
	identity			int // 0 = follower, 1 = candidate, 2 = leader
	rand 				*rand.Rand // Per-server random number generator
	lastContact			time.Time // last time able to reach the majority
	firstIndexEachTerm	map[int]int
}

// self
func (rf *Raft) ResetElectionTimeout() {
	min_timeout := 300
	max_timeout := 600
	// rf.mu.Lock()
	rf.electionTimeout = time.Duration(min_timeout + rf.rand.Intn(max_timeout - min_timeout)) * time.Millisecond
	// rf.mu.Unlock()
}


// return currentTerm and whether this server
// believes it is the leader.
func (rf *Raft) GetState() (int, bool) {
	var term int
	var isleader bool
	// Your code here (3A)
	rf.mu.Lock()
	defer rf.mu.Unlock()
	term = rf.currentTerm
	isleader = rf.identity == 2
	// fmt.Printf("id: %v, term: %v, isLeader: %v\n", rf.me, term, isleader)
	return term, isleader
}

//
// save Raft's persistent state to stable storage,
// where it can later be retrieved after a crash and restart.
// see paper's Figure 2 for a description of what should be persistent.
//
func (rf *Raft) persist() {
	// Your code here (3C).
	// Example:
	// w := new(bytes.Buffer)
	// e := labgob.NewEncoder(w)
	// e.Encode(rf.xxx)
	// e.Encode(rf.yyy)
	// data := w.Bytes()
	// rf.persister.SaveRaftState(data)
	// self
	// rf.mu.Lock()
	// defer rf.mu.Unlock()
	w := new(bytes.Buffer)
	e := labgob.NewEncoder(w)
	e.Encode(rf.currentTerm)
	e.Encode(rf.votedFor)
	e.Encode(rf.logEntries)
	data := w.Bytes()
	rf.persister.SaveRaftState(data)
}

//
// restore previously persisted state.
//
func (rf *Raft) readPersist(data []byte) {
	if data == nil || len(data) < 1 { // bootstrap without any state?
		return
	}
	// Your code here (3C).
	// Example:
	// r := bytes.NewBuffer(data)
	// d := labgob.NewDecoder(r)
	// var xxx
	// var yyy
	// if d.Decode(&xxx) != nil ||
	//    d.Decode(&yyy) != nil {
	//   error...
	// } else {
	//   rf.xxx = xxx
	//   rf.yyy = yyy
	// }
	r := bytes.NewBuffer(data)
	d := labgob.NewDecoder(r)
	var currentTerm int
	var votedFor int
	var logEntries []*LogEntry
	if err := d.Decode(&currentTerm); err != nil {
		log.Fatalf("Failed to decode currentTerm: %v", err)
	} 
	if err := d.Decode(&votedFor); err != nil {
		log.Fatalf("Failed to decode votedFor: %v", err)
	} 
	if err := d.Decode(&logEntries); err != nil {
		log.Fatalf("Failed to decode logEntries: %v", err)
	} 
	rf.mu.Lock()
	rf.currentTerm = currentTerm
	rf.votedFor = votedFor
	rf.logEntries = logEntries
	rf.mu.Unlock()
	// rf.persist()

}


// self - AppendEntries RPC struct
type AppendEntriesArgs struct {
	Term			int // leader’s term
	LeaderId		int // so follower can redirect clients
	PrevLogIndex 	int // index of log entry immediately preceding new ones
	PrevLogTerm 	int // term of prevLogIndex entry
	Entries 		[]*LogEntry // log entries to store (empty for heartbeat; may send more than one for efficiency)
	LeaderCommit	int // leader’s commitIndex
}

// self - AppendEntries
type AppendEntriesReply struct {
	// Your data here (3A).
	Term 			  		int // currentTerm, for candidate to update itself
	Success			  		bool // true means candidate received vote
	TermOfConflictEntry 	int 
	FirstIndex  	  		int 
}

// self - send a AppendEntries RPC to a server
func (rf *Raft) sendAppendEntries(server int, args *AppendEntriesArgs, reply *AppendEntriesReply) bool {
	ok := rf.peers[server].Call("Raft.AppendEntries", args, reply)
	return ok
}

func min(a, b int) int {
	if a < b {
		return a 
	} else {
		return b 
	}
}


// self - AppendEntries RPC handler
func (rf *Raft) AppendEntries(args *AppendEntriesArgs, reply *AppendEntriesReply) {
	rf.mu.Lock()
	defer rf.mu.Unlock()

	reply.TermOfConflictEntry = -1 
	reply.FirstIndex = -1

	if args.Term < rf.currentTerm {
		reply.Success = false 
		reply.Term = rf.currentTerm
		return
	}

	if args.Term > rf.currentTerm {
		rf.currentTerm = args.Term
		rf.identity = 0 
		rf.votedFor = -1
		rf.persist()
		// rf.lastHeartbeat = time.Now()
		// rf.ResetElectionTimeout()
	}

	rf.lastHeartbeat = time.Now()
	rf.ResetElectionTimeout()
	
	if args.PrevLogIndex >= len(rf.logEntries) || rf.logEntries[args.PrevLogIndex].Term != args.PrevLogTerm {
		if args.PrevLogIndex < len(rf.logEntries) {
			reply.TermOfConflictEntry = rf.logEntries[args.PrevLogIndex].Term
			reply.FirstIndex = rf.firstIndexEachTerm[rf.logEntries[args.PrevLogIndex].Term]
			rf.logEntries = rf.logEntries[:args.PrevLogIndex]
			rf.persist()
		}
		reply.Success = false 
		reply.Term = rf.currentTerm
		return 
	} 

	for i := 0; i < len(args.Entries); i++ {
		ld_ind := args.PrevLogIndex + i + 1
		if ld_ind < len(rf.logEntries) && rf.logEntries[ld_ind].Term == args.Entries[i].Term {
			continue
		} else {
			rf.logEntries = rf.logEntries[: ld_ind]
			rf.logEntries = append(rf.logEntries, args.Entries[i])
			rf.persist()
			// if the new-appended log has different term than the previous log, mark its index as the ind of the first log of that term
			if rf.logEntries[len(rf.logEntries)-2].Term < rf.logEntries[len(rf.logEntries)-1].Term {
				rf.firstIndexEachTerm[rf.logEntries[len(rf.logEntries)-1].Term] = len(rf.logEntries)-1
			}
		}
	}

	reply.Success = true 
	// rf.lastHeartbeat = time.Now()
	// rf.ResetElectionTimeout()

	// check commit index 
	if args.LeaderCommit > rf.commitIndex {
		rf.commitIndex = min(args.LeaderCommit, len(rf.logEntries) - 1)
		
		// apply the entry
		for rf.lastApplied < rf.commitIndex {
			rf.lastApplied++
			applymsg := ApplyMsg{
				CommandValid: true,
				Command: rf.logEntries[rf.lastApplied].Command,
				CommandIndex: rf.lastApplied,
			}
			// fmt.Printf("peer %v is going to apply cmd %v, lastApplied: %v, rf.commitInd: %v\n", rf.me, rf.logEntries[rf.lastApplied].Command, rf.lastApplied, rf.commitIndex)
			rf.applyCh <- applymsg
			// fmt.Printf("peer %v finished applying cmd %v, lastApplied: %v, rf.commitInd: %v\n", rf.me, rf.logEntries[rf.lastApplied].Command, rf.lastApplied, rf.commitIndex)
		}
	} 

	rf.lastHeartbeat = time.Now()
	reply.Term = rf.currentTerm
	// return
}

//
// example RequestVote RPC arguments structure.
// field names must start with capital letters!
//
type RequestVoteArgs struct {
	// Your data here (3A, 3B).
	Term			 int // candidate's term
	CandidateId      int // candidate requesting vode
	LastLogIndex     int // index of candidate’s last log entry
	LastLogTerm   	 int // term of candidate’s last log entry
}

//
// example RequestVote RPC reply structure.
// field names must start with capital letters!
//
type RequestVoteReply struct {
	// Your data here (3A).
	Term 			  int // currentTerm, for candidate to update itself
	VoteGranted       bool // true means candidate received vote
}

//
// example RequestVote RPC handler.
//
func (rf *Raft) RequestVote(args *RequestVoteArgs, reply *RequestVoteReply) {
	// Your code here (3A, 3B).
	rf.mu.Lock()
	defer rf.mu.Unlock()
	
	// voter_original_term := rf.currentTerm

	if args.Term > rf.currentTerm {
		rf.currentTerm = args.Term
		rf.identity = 0 // convert to follower
		rf.votedFor = -1 
		rf.persist()
		// rf.lastHeartbeat = time.Now()
		// rf.ResetElectionTimeout()
	} else if args.Term < rf.currentTerm { 
		reply.VoteGranted = false 
		reply.Term = rf.currentTerm
		return
	} 
	reply.Term = rf.currentTerm
	if rf.logEntries[len(rf.logEntries)-1].Term < args.LastLogTerm || (rf.logEntries[len(rf.logEntries)-1].Term == args.LastLogTerm && len(rf.logEntries) - 1 <= args.LastLogIndex) {
		if (rf.votedFor == -1 || rf.votedFor == args.CandidateId) {
			reply.VoteGranted = true 
			rf.votedFor = args.CandidateId
			rf.persist()
			rf.identity = 0
			rf.lastHeartbeat = time.Now() // Optional
			rf.ResetElectionTimeout()
			
		} else {
			reply.VoteGranted = false 
		}
	} else {
		reply.VoteGranted = false 
	}

	
	// rf.lastHeartbeat = time.Now() // Optional
	
	// fmt.Printf("peer %v voted %v for candidate %v. voter original term: %v, candidate term: %v\n", rf.me, reply.VoteGranted, args.CandidateId, voter_original_term, args.Term)

}

//
// example code to send a RequestVote RPC to a server.
// server is the index of the target server in rf.peers[].
// expects RPC arguments in args.
// fills in *reply with RPC reply, so caller should
// pass &reply.
// the types of the args and reply passed to Call() must be
// the same as the types of the arguments declared in the
// handler function (including whether they are pointers).
//
// The labrpc package simulates a lossy network, in which servers
// may be unreachable, and in which requests and replies may be lost.
// Call() sends a request and waits for a reply. If a reply arrives
// within a timeout interval, Call() returns true; otherwise
// Call() returns false. Thus Call() may not return for a while.
// A false return can be caused by a dead server, a live server that
// can't be reached, a lost request, or a lost reply.
//
// Call() is guaranteed to return (perhaps after a delay) *except* if the
// handler function on the server side does not return.  Thus there
// is no need to implement your own timeouts around Call().
//
// look at the comments in ../labrpc/labrpc.go for more details.
//
// if you're having trouble getting RPC to work, check that you've
// capitalized all field names in structs passed over RPC, and
// that the caller passes the address of the reply struct with &, not
// the struct itself.
//
func (rf *Raft) sendRequestVote(server int, args *RequestVoteArgs, reply *RequestVoteReply) bool {
	ok := rf.peers[server].Call("Raft.RequestVote", args, reply)
	return ok
}


func (rf *Raft) UpdateCommitIndex() {
	// rf.mu.Lock()
	// defer rf.mu.Unlock()
	matchIndices := make([]int, len(rf.matchIndex))
	copy(matchIndices, rf.matchIndex)
	sort.Ints(matchIndices)
	
	

	N := matchIndices[len(matchIndices)/2]
	if N > rf.commitIndex && rf.logEntries[N].Term == rf.currentTerm {
		rf.commitIndex = N
		// fmt.Printf("ld %v commitInd update to %v\n", rf.me, rf.commitIndex)
		// fmt.Printf("")
	} 

	// fmt.Printf("ld %v's matchIndices: %v, N: %v, rf.logEntries[N].Term: %v, rf.currentTerm: %v\n", rf.me, matchIndices, N, rf.logEntries[N].Term, rf.currentTerm)
	
	for rf.lastApplied < rf.commitIndex {
		rf.lastApplied++
		// apply the entry
		applymsg := ApplyMsg{
			CommandValid: true,
			Command: rf.logEntries[rf.lastApplied].Command,
			CommandIndex: rf.lastApplied,
		}
		// fmt.Printf("ld %v is going to apply cmd %v. lastApplied: %v, rf.commitInd: %v\n", rf.me, rf.logEntries[rf.lastApplied].Command, rf.lastApplied, rf.commitIndex)
		rf.applyCh <- applymsg
		// fmt.Printf("ld %v finished applying cmd %v, lastApplied: %v, rf.commitInd: %v\n", rf.me, rf.logEntries[rf.lastApplied].Command, rf.lastApplied, rf.commitIndex)
	} 
	
	return
}

func (rf *Raft) ReplicateLog(peerInd int, logentry *LogEntry) {
	// stopSending := make(chan struct{})
	// var once sync.Once
	// var mu sync.Mutex
	for !rf.killed() {
		rf.mu.Lock()
		if rf.identity != 2 {
			rf.mu.Unlock()
			return
		}

		var ok bool 
		var reply AppendEntriesReply
		var args AppendEntriesArgs
		// If last log index ≥ nextIndex for a follower: send AppendEntries RPC with log entries starting at nextIndex
		if len(rf.logEntries)-1 >= rf.nextIndex[peerInd] {
			// fmt.Printf("ld %v's matchIndex before appendEntry to peer %v: %v, nextIndex: %v, num_entries to append: %v, prevlogind: %v\n", rf.me, peerInd, rf.matchIndex, rf.nextIndex, len(rf.logEntries[rf.nextIndex[peerInd]:]), rf.nextIndex[peerInd] - 1)
			args = AppendEntriesArgs{
				Term:         rf.currentTerm,
				LeaderId:     rf.me,
				PrevLogIndex: rf.nextIndex[peerInd] - 1, // len(rf.logEntries) - 1,
				PrevLogTerm:  rf.logEntries[rf.nextIndex[peerInd] - 1].Term,// rf.logEntries[len(rf.logEntries) - 1].Term,
				Entries:      rf.logEntries[rf.nextIndex[peerInd]:],
				LeaderCommit: rf.commitIndex,
			}

			rf.mu.Unlock()

			reply = AppendEntriesReply{}
			
			ok = rf.sendAppendEntries(
				peerInd,
				&args,
				&reply,
			)
			if ok {
				rf.mu.Lock()
				if reply.Term > rf.currentTerm {
					rf.identity = 0
					rf.votedFor = -1
					rf.currentTerm = reply.Term
					rf.persist()
					// rf.lastHeartbeat = time.Now()
					// rf.ResetElectionTimeout()
					rf.mu.Unlock()
					return
				}
				if reply.Success {
					//  update nextIndex and matchIndex for follower
					rf.nextIndex[peerInd] = args.PrevLogIndex + len(args.Entries) + 1
					rf.matchIndex[peerInd] = rf.nextIndex[peerInd] - 1// args.PrevLogIndex + len(args.Entries)

					// fmt.Printf("ld: %v successfully replicated log on peer %v, rf.matchIndex: %v ld log: %v\n", rf.me, peerInd, rf.matchIndex, rf.logEntries)
					// check if to commit
					rf.UpdateCommitIndex()
					rf.mu.Unlock()
					return
				} else {
					// If AppendEntries fails because of log inconsistency: decrement nextIndex and retry
					// fmt.Printf("!reply.Success: ld %v failed to replicate log on peer %v\n", rf.me, peerInd)
					if reply.FirstIndex == -1 {
						rf.nextIndex[peerInd] = max(1, rf.nextIndex[peerInd] - 1)
					} else {
						rf.nextIndex[peerInd] = max(1, reply.FirstIndex)
					}
					
					// if rf.nextIndex[peerInd] > 1 {
					// 	rf.nextIndex[peerInd]--
					// }
					rf.mu.Unlock()
				}
			} else {
				time.Sleep(10 * time.Millisecond)
				// fmt.Printf("network failure when replicating\n")
				// rf.mu.Lock()
				// fmt.Printf("network failure: ld %v failed to replicate log on peer %v\n", rf.me, peerInd)
				// rf.mu.Unlock()
				// continue
			
			}
		} else {
			rf.mu.Unlock()
			return
		}
	}
	// rf.mu.Lock()
	// rf.identity = 0
	// rf.votedFor = -1
	// rf.lastHeartbeat = time.Now()
	// rf.ResetElectionTimeout()
	// rf.mu.Unlock()
	// return
}


//
// the service using Raft (e.g. a k/v server) wants to start
// agreement on the next command to be appended to Raft's log. if this
// server isn't the leader, returns false. otherwise start the
// agreement and return immediately. there is no guarantee that this
// command will ever be committed to the Raft log, since the leader
// may fail or lose an election. even if the Raft instance has been killed,
// this function should return gracefully.
//
// the first return value is the index that the command will appear at
// if it's ever committed. the second return value is the current
// term. the third return value is true if this server believes it is
// the leader.
//
func (rf *Raft) Start(command interface{}) (int, int, bool) {
	index := -1
	term := -1
	isLeader := true

	// Your code here (3B).
	// term, isLeader = rf.GetState()
	// the index that the command will appear at if it's ever committed
	rf.mu.Lock()
	index = len(rf.logEntries) 
	term = rf.currentTerm
	isLeader = rf.identity == 2
	if !isLeader {
		rf.mu.Unlock()
		return index, term, isLeader
	}

	logentry := &LogEntry {
		Term: rf.currentTerm,
		Command: command,
	}
	
	rf.logEntries = append(rf.logEntries, logentry)
	rf.persist()
	rf.nextIndex[rf.me] = len(rf.logEntries)
	rf.matchIndex[rf.me] = len(rf.logEntries) - 1
	rf_peers := rf.peers 
	ld_id := rf.me
	rf.mu.Unlock()

	for ind, _ := range rf_peers{
		if ind != ld_id {
			go rf.ReplicateLog(ind, logentry)
		}
		
	}

	return index, term, isLeader
}

//
// the tester doesn't halt goroutines created by Raft after each test,
// but it does call the Kill() method. your code can use killed() to
// check whether Kill() has been called. the use of atomic avoids the
// need for a lock.
//
// the issue is that long-running goroutines use memory and may chew
// up CPU time, perhaps causing later tests to fail and generating
// confusing debug output. any goroutine with a long-running loop
// should call killed() to check whether it should stop.
//
func (rf *Raft) Kill() {
	atomic.StoreInt32(&rf.dead, 1)
	// Your code here, if desired.
}

func (rf *Raft) killed() bool {
	z := atomic.LoadInt32(&rf.dead)
	return z == 1
}



func (rf *Raft) send_heartbeats() {
	for !rf.killed() {
		rf.mu.Lock()
		if rf.identity != 2 {
			rf.mu.Unlock()
			return
		}
		rf_me := rf.me 
		rf_peers := rf.peers 
		majority := len(rf.peers) / 2 + 1
		rf.mu.Unlock()

		successCnt := 1 
		// var wg sync.WaitGroup 
		var mu sync.Mutex

		for peerInd := range rf_peers {
			if peerInd == rf_me {
				continue 
			}

			// wg.Add(1)
			go func(peerInd int) {
				// defer wg.Done()
				rf.mu.Lock()

				if rf.identity != 2 {
					rf.mu.Unlock()
					return
				}

				args := AppendEntriesArgs{
					Term: rf.currentTerm,
					LeaderId: rf.me,
					PrevLogIndex: len(rf.logEntries) - 1,
					PrevLogTerm: rf.logEntries[len(rf.logEntries) - 1].Term,
					Entries: []*LogEntry{},
					LeaderCommit: rf.commitIndex,
				}
				// fmt.Printf("term %v leader %v is going to sent heartbeat to peer %v\n", rf.currentTerm, rf.me, peerInd)
				rf.mu.Unlock()

				reply := AppendEntriesReply{}
				
				ok := rf.sendAppendEntries(
					peerInd, 
					&args, 
					&reply,
				) 

				rf.mu.Lock()
				
				if ok {
					if reply.Term > rf.currentTerm {
						rf.identity = 0
						rf.votedFor = -1
						rf.currentTerm = reply.Term 
						rf.persist()
						// fmt.Printf("leader %v term %v is smaller than peer %v term %v\n", rf.me, rf.currentTerm, peerInd, reply.Term)
						rf.mu.Unlock()
						return 
					}

					mu.Lock()
					successCnt++
					if successCnt >= majority {
						rf.lastContact = time.Now()
					}
					mu.Unlock()
					
					// fmt.Printf("leader %v successfully sent heartbeat to peer %v\n", rf.me, peerInd)					
				} 
				rf.mu.Unlock()
			} (peerInd)
		}
		// wg.Wait()

		// rf.mu.Lock()
		// mu.Lock()
		// if successCnt >= majority {
		// 	rf.lastContact = time.Now()
		// }
		// mu.Unlock()
		// rf.mu.Unlock()

		time.Sleep(100 * time.Millisecond)

	}
	
}

func (rf *Raft) launch_election() {
	rf.mu.Lock()
	rf.currentTerm += 1
	rf.votedFor = rf.me 
	rf.persist()
	rf.lastHeartbeat = time.Now()
	rf.ResetElectionTimeout()
	rf.mu.Unlock()

	// Send RequestVote RPCs to all other servers
	// var wg sync.WaitGroup
	var nvotes int32 = 1
	// var numvotes int32
	majority := int32(len(rf.peers) / 2 + 1)
	stopElection := make(chan struct{})
	var once sync.Once

	for ind, _ := range rf.peers {
		if ind == rf.me {
			continue
		}
		// wg.Add(1)
		go func(peerInd int) {
			// defer wg.Done()
			rf.mu.Lock()
			lastlogterm := 0
			lastlogindex := 0
			if len(rf.logEntries) > 0 {
				lastlogterm = rf.logEntries[len(rf.logEntries) - 1].Term
				lastlogindex = len(rf.logEntries) - 1
			} 
			args := RequestVoteArgs{
				Term: rf.currentTerm,
				CandidateId: rf.me,
				LastLogIndex: lastlogindex, // rf.lastLogIndex,
				LastLogTerm: lastlogterm,
			}
			rf.mu.Unlock()
			
			reply := RequestVoteReply{}

			ok := rf.sendRequestVote(
				peerInd, 
				&args, 
				&reply,
			) 
			select {
			case <- stopElection:
				return
			default:
				if ok {
					// if vote is obtained, count
					rf.mu.Lock()
					if rf.currentTerm < reply.Term {
						rf.identity = 0 
						rf.votedFor = -1 
						rf.currentTerm = reply.Term 
						rf.persist()
						// rf.lastHeartbeat = time.Now()
						// rf.ResetElectionTimeout()
						rf.mu.Unlock()
						once.Do(func() {close(stopElection)})
						return
					} 
					if reply.VoteGranted { // && reply.Term == rf.currentTerm 
						atomic.AddInt32(&nvotes, 1)
						// fmt.Printf("candidate %v with term %v receives vote from peer %v\n", rf.me, rf.currentTerm, peerInd)
						// once obtain majority votes, becomes leader
						if atomic.LoadInt32(&nvotes) >= majority {
							// rf.mu.Lock()
							rf.identity = 2 // becomes leader
							// rf.send_heartbeats()
							go rf.send_heartbeats()
							for i := range rf.peers {
								// initialized to leader last log index + 1
								rf.nextIndex[i] = len(rf.logEntries)
								rf.matchIndex[i] = 0
							}
							// signal to stop further voting
							once.Do(func() {close(stopElection)})
							// fmt.Printf("candidate %v becomes leader of term %v, nvotes: %v\n", rf.me, rf.currentTerm, atomic.LoadInt32(&nvotes))
						}
						// rf.mu.Unlock()
					} 
					rf.mu.Unlock()
				} 
			}
		} (ind)
	}

}


// The ticker go routine starts a new election if this peer hasn't received
// heartsbeats recently.
func (rf *Raft) ticker() {
	// _, isleader := rf.GetState()
	for !rf.killed(){
		time.Sleep(time.Duration(10) * time.Millisecond)
		rf.mu.Lock()

		// Your code here to check if a leader election should
		// be started and to randomize sleeping time using
		// time.Sleep().

		if rf.identity == 2 && time.Since(rf.lastContact) > rf.electionTimeout {
			rf.identity = 0
			rf.votedFor = -1 
			rf.persist()
			rf.lastHeartbeat = time.Now()
			rf.ResetElectionTimeout()
			rf.mu.Unlock()
			continue
		}
		if rf.identity != 2 && time.Since(rf.lastHeartbeat) > rf.electionTimeout { //&& rf.votedFor == -1
			rf.identity = 1 
			// fmt.Printf("candidate %v launched an election, new candidate term: %v, electionTimeout: %v\n", rf.me, rf.currentTerm + 1, rf.electionTimeout)
			rf.mu.Unlock()
			rf.launch_election()
			
		} else {
			rf.mu.Unlock()
		}
	}
}

//
// the service or tester wants to create a Raft server. the ports
// of all the Raft servers (including this one) are in peers[]. this
// server's port is peers[me]. all the servers' peers[] arrays
// have the same order. persister is a place for this server to
// save its persistent state, and also initially holds the most
// recent saved state, if any. applyCh is a channel on which the
// tester or service expects Raft to send ApplyMsg messages.
// Make() must return quickly, so it should start goroutines
// for any long-running work.
//
func Make(peers []*labrpc.ClientEnd, me int,
	persister *Persister, applyCh chan ApplyMsg) *Raft {
	rf := &Raft{}
	
	rf.peers = peers
	rf.persister = persister
	rf.me = me

	// Your initialization code here (3A, 3B, 3C).
	rf.currentTerm = 0
	rf.votedFor = -1
	rf.logEntries = []*LogEntry{
		&LogEntry {
			Term: 0,
			Command: nil,
		},
	}
	rf.commitIndex = 0
	rf.lastApplied = 0
	rf.nextIndex = make([]int, len(peers))// []int{}
	rf.matchIndex = make([]int, len(peers)) // []int{}
	rf.firstIndexEachTerm = make(map[int]int)
	for i := range rf.peers {
		rf.nextIndex[i] = 1
		rf.matchIndex[i] = 0
	}
	rf.applyCh = applyCh
	rf.identity = 0 
	// rf.nvotes = 0
	rf.rand = rand.New(rand.NewSource(time.Now().UnixNano() + int64(me)*1000))

	// Randomize election timeout between 300ms and 500ms
	// rf.electionTimeout = time.Duration((me+1) * 150 + (me+1) * rand.Intn(100)) * time.Millisecond
	rf.lastHeartbeat = time.Now()
	rf.ResetElectionTimeout()
	// initialize from state persisted before a crash
	rf.readPersist(persister.ReadRaftState())

	// start ticker goroutine to start elections
	go rf.ticker()

	return rf
}
