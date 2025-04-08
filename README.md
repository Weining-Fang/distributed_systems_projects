# Distributed Systems Projects
 
This repo includes projects related to distributed systems I have completed. Brief introduction of each project:  
    
## Single-node Video Recommendation Service  
•	A gRPC-based video recommendation service, integrating UserService and VideoService to provide personalized ranked video recommendations;  
•	Engineered concurrent RPC handling with error handling and retries; implemented batching logic to optimize API requests; built a caching mechanism for fallback recommendations.  

## Raft Distributed Consensus Implementation  
•	Reproduced the Raft consensus algorithm, following the original Raft paper to achieve leader election, log replication, and fault tolerance across distributed nodes;  
•	Developed persistent state storage enabling log recovery across crashes and ensuring safety guarantees;  
•	Implemented randomized election timeouts and heartbeat mechanisms to maintain consensus and prevent split votes; applied log replication and commit indexing to ensure consistent command execution.   

## Sharded and Replicated Key-Value Cache  
•	Implemented a distributed in-memory key-value store with dynamic sharding and replication; Engineered a multi-threaded storage engine using fine-grained locking to handle concurrent Get, Set and Delete operations;   
•	Implemented shard migration protocols and shard-aware request routing with failover handling and load balancing; integrated TTL-based expiration and garbage collection mechanisms to manage cached data.  

## Simulated Multi-GPU Communication and Coordination Framework  
•	Built a distributed machine learning runtime that simulates GPU collective operations across multiple devices using gRPC; implemented core components including a GPUDevice service, a GPUCoordinator, and client-side orchestration logic;  
•	Designed and implemented a ring-based AllReduce algorithm, mimicking NCCL-style asynchronous collectives with BeginSend, StreamSend, and stream status polling to simulate non-blocking GPU behavior;  
•	Simulated host-to-device and device-to-host memory transfers with address range validation and file-backed memory models; implemented error handling, communicator lifecycle management, and device failure detection logic;  
•	Focused on correctness, extensibility, and educational clarity over performance realism, while drawing inspiration from real-world systems like CUDA, NCCL, and gloo.  
