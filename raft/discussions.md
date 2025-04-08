#### 3A-2
(1)  
Suppose a Raft cluster has 3 nodes a, b, c, their election timeout has been initialized to close numbers say,
electionTimeout_a = 510ms, electionTimeout_b = 508ms, electionTimeout_c = 520ms.  
At the initialization stage, these three nodes were initialized at the same time. Since they started at the same 
time, and have very close electionTimeout, they are very likely to launch elections "almost" at the same time with 
the same new term (say, term 1). Since none of the candidates have a higher term than the other, none of the 3 nodes would grant vote to any candidates other than itself, thus leading to the situation in which all nodes keeping launching and then failing elections due to almost the same timeout, and no leader get elected.   

(2) Raft prevents split vote with random election timeout mechenism, in which election timer of a node is reset to a random value (a value that is differentiable enough from other nodes, such that a node can get timeout and launch election, send vote request, wins election, and send heartbeat before other nodes gets timeout) upon launching election, receiving AppendEntries RPC from the current leader, and granting a vote to a candidate.  In addition, in real-world practice, factors like network and processing delays can also introduce minor variations in timing, further lowering the chance for Raft to experience split vote and indefinite election failures.  


#### ExtraCredit1    
The scenario I constructed above may be resolved with Pre-Vote and CheckQuorum only if a leader has been elected. Once a leader gets elected, CheckQuorum ensures that it stays in leadership as long as it is able to contact the majority by receiving valid AppendEntries replies; since a server only give pre-vote if it has not received heartbeat from the current leader within the election timeout and if the candidate's log is at least as up-to-date as its own, the candidates will not increment their term if they fail a PreVote, thus reducing the disruption to the current leader. However, Pre-Vote and CheckQuorum cannot address the initial split vote issue if no leader is elected from the beginning.  