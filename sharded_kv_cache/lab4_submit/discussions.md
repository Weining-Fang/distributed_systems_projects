#### A4
What tradeoffs did you make with your TTL strategy? How fast does it clean up data and how expensive is it in terms of number of keys?  
I chose to implement a periodic garbage collection strategy instead of an immediate deletion on detecting expiry during Get(). Compared to immediate deletion, the periodic garbage collection strategy reduced the number of operations in Get() so that it does not need to check if a key has expired and do deletion if necessary, which can help minimize per-request overhead during high traffic. Also, periodic garbage collector make sure that all data expired, including those that have not been accessed yet, are cleaned on time, preventing stale data and reducing the overall system overhead. However, having this strategy running in the background concurrently consumes memory resource and computational power consistently.   

If the server was write intensive, would you design it differently? How so?   
Currently I set the cleanup to run every 300ms. The cost of the cleanup linearly increase with the number of keys in each shard. 
If the server was write intensive, there will be more frequent write locks, and the current implementation of also frequent cleanup may introduce contention and delay. I may consider reducing the frequency by increasing time.Sleep() between cleanups, or complement it with immediate deletion.  

#### B2
What flaws could you see in the load balancing strategy you chose? Consider cases where nodes may naturally have load imbalance already -- a node may have more CPUs available, or a node may have more shards assigned.  
I used round robin for load balancing, which assumes all nodes have equal capacity. If some of the nodes have more CPUs, memory or network resources available, then using round robin would leave these nodes underused while others are overwhelmed. Nor do round robin account for number of shards hosted on each node, which has the heavy-loaded nodes handle as many requests as the light-loaded ones. Moreover, if certain shards experience higher traffic but have not been distributed well on different nodes, round robin cannot leviate this type of situation either.  

What other strategies could help in this scenario? You may assume you can make any changes to the protocol or cluster operation.   
To address these issues, I may introduce weights to nodes based on their capacity and load, taking factors such as number of CPUs, memory, network resources, number of shards, and request frequencies to the shards hosted on the node into account. The weights could be updated dynamically based on the change in the states mentioned before.  

#### B3
For this lab you will try every node until one succeeds. What flaws do you see in this strategy? What could you do to help in these scenarios?  
If multiple nodes are unreachable, this will accumulate high latency. Furthermore, in high QPS scenarios, there will be large amount of serial repeated retries piled up, increasing system load and overwhelming nodes especially nodes that are alive.  

To mitigate this, I may implement mechanism like sending heartbeats in the background to keep track of which nodes are reachable, or keep a dynamically updated record of the most recent successful request sent to each node, and directly route requests to the nodes receiving heartbeat most recently or have responded to a request without error most recently.    


#### D2  
1. High read-write workload
command:  
sudo go run cmd/stress/tester.go --shardmap shardmaps/test-5-node.json --get-qps=300 --set-qps=150 --duration=120s
result:  
Get requests: 36020/36020 succeeded = 100.000000% success rate
Set requests: 18020/18020 succeeded = 100.000000% success rate
Correct responses: 36000/36000 = 100.000000%
Total requests: 54040 = 450.322383 QPS  

2. Many read&write targetting on a small set of keys with short TTLs
command:  
sudo go run cmd/stress/tester.go --shardmap shardmaps/test-5-node.json --get-qps=500 --set-qps=50 --num-keys=2 --ttl=500ms --duration=90s
result:  
Get requests: 45020/45020 succeeded = 100.000000% success rate
Set requests: 4520/4520 succeeded = 100.000000% success rate
Correct responses: 42169/42169 = 100.000000%
Total requests: 49540 = 550.427777 QPS  