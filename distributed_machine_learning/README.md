A Simulated Multi-GPU Communication and Coordination Framework  

Design and Implementation OverView  
The system comprises three main components:  
1. GPUDevice Service: Simulates a single GPU, exposing RPCs for memory operations and non-blocking sends/receives.  
2. GPUCoordinator Service: Manages sets of GPU devices as communicators. It initializes communicators, assigns devices, starts and ends collective groups, orchestrates AllReduce, and handles communicator finalization.  
3. Client Logic (Coordinator Client): Represents the appli-cation logic that communicates with the GPUCoordinator to perform operations like CommInit, Memcpy, AllRe-duce, and CommFinalize.  

Communication Model  
We rely on a simplified message-based communication model.  
GPUDevice Service  
• GetDeviceMetadata: Returns device ID, rank, and memory address ranges.  
• BeginSend/BeginReceive: Non-blocking calls that initiate a data transfer. These calls return immediately but set up a state for subsequent streaming.  
• StreamSend/StreamReceive: Streaming RPCs where the actual data bytes are transferred.  
• GetStreamStatus: Queries the status of a stream to deter-mine if operations have completed successfully.  
GPUCoordinator Service    
• CommInit/CommFinalize/CommDestroy: These APIs manage the lifecycle of a communicator. On CommInit, a specified number of devices are allocated from a pool and assigned ranks. CommFinalize cleans up the communicator, and CommDestroy handles abnormal teardown.  
• GroupStart/GroupEnd: Mark the start and end of collec-tive operations.  
• AllReduceRing: Implements a ring-based AllReduce algo-rithm. The coordinator instructs each device to send data to the next device in a logical ring. After data shuffling, the coordinator gathers all data, reduces it, and writes the result back to each device.  
• Memcpy (Host-to-Device and Device-to-Host): Allows data injection from host memory or extraction of device memory. Internally, this uses the device’s streaming APIs to simulate data movement.  
  
Memory and Addressing  
Each device simulates a memory space and accepts host-to-device or device-to-host transfers. Addresses are checked against device memory ranges. This check ensures correct-ness and provides a simplified model of GPU memory management. Host-to-device transfers involve a Memcpy call that uses BeginSend and StreamSend under the hood, while device-to-host uses StreamReceive.  

AllReduceRing  
We implement a ring-based AllReduce to demonstrate col-lective operations. The coordinator:  
1. Initiates sends and receives along a ring topology estab-lished by device ranks.  
2. Each device transfers data to the next device’s memory space.  
3. After the ring step, the coordinator collects all data, re-duces it, and writes the result back to each device.  
By using floats for AllReduce, we can simulate operations like SUM and ensure correctness through tests that verify final data consistency.  

Error Handling and Finalization  
If a device fails or a memory request is invalid (out-of-range addresses), we propagate errors back through gRPC responses and may mark a communicator as FAILED. On finalization, we free devices and destroy the communicator state. This simulates real-world scenarios where a commu-nicator must be cleaned up at the end of a training epoch or after a fault.  

Design Options and Tradeoffs  
Transport Choice   
Our framework uses gRPC as the primary communication mechanism for all device-to-coordinator and (logically) device-to-device interactions. This choice greatly simplifies the development process due to automatic code generation, built-in streaming support, and language-agnostic interfaces. However, gRPC introduces layers of abstraction and com-putational overhead compared to lower-level transports. In real GPU collectives, developers might rely on RDMA, NVLink, NCCL’s CUDA-aware sockets, or direct shared memory transfers to achieve near-native hardware band-width and latency. Those solutions would be significantly more complex to implement and maintain.  
By choosing gRPC, we gain simplicity, portability, and extensibility at the cost of realism and raw performance fidelity. Since our goal is to simulate the logic of GPU collectives rather than to benchmark performance at scale, the overhead is acceptable. In a production-grade system or a high-performance training environment, the complexity of lower-level IPC might be justified to meet strict latency and throughput demands.  

Memory Model and Addressing Scheme  
Each GPUDevice stores data in a simple map[memAddr][]byte, simulating GPU memory as a key-value store. This is a stark departure from real GPU memory management, which involves pinned buffers, CUDA streams, and memory registration for RDMA or GPU-direct technologies. Our simplified model allows us to store and retrieve data easily while enforcing a basic ad-dress range check to ensure correctness.  
The tradeoff here is between simplicity and realism. By avoiding complex memory management, we can easily test and debug the system’s logic—such as whether AllReduce operations complete successfully, or if data actually moves between devices as intended. However, this means we lose the opportunity to model advanced performance features like asynchronous DMA transfers, memory alignment con-straints, and zero-copy operations, all of which are critical to high-performance GPU communication libraries. Had we chosen a more realistic model, we would have dealt with intricate memory registration steps, potentially adding sub-stantial complexity and code overhead.  

Asynchronous vs. Synchronous Operations  
The current design separates the “initiation” of sends/receives (via BeginSend and BeginReceive) from the actual data transfer streams (StreamSend and StreamRe-ceive), mimicking non-blocking behavior. In an actual GPU communication library, asynchronous operations al-low overlapping computation and communication, improv-ing performance.  
We model asynchronicity conceptually but do not deeply simulate scheduling, concurrency control, or progress en-gines that real asynchronous runtimes would require. The tradeoff is that we keep the conceptual model of asynchro-nous operations—helping users reason about how non-blocking collectives might work—without fully imple-menting complex thread pools, event loops, or GPU streams. A fully asynchronous simulation might provide more insight into concurrency issues but at the expense of substantially more code and potential for race conditions or subtle bugs.  

AllReduce Implementation  
We focused on a ring-based AllReduce, a known efficient algorithm on large GPU clusters [3]. Alternatives like tree-based or recursive-doubling algorithms might be explored for performance. We chose the ring approach because of its simplicity and well-understood performance characteristics.  

Fault Handling  
The framework opts for simple error detection and immedi-ate communicator invalidation upon failures such as invalid memory addresses or device errors. This minimalistic fault model makes it easy to maintain a stable codebase: when something goes wrong, the communicator is marked as failed, and all involved devices are released.  
The downside is a lack of nuanced fault tolerance. Real HPC frameworks often implement strategies like partial communicator recovery, retry mechanisms, or check-point/restart semantics. Implementing these features would significantly increase complexity and code size. Our tradeoff prioritizes a clear failure model and simple cleanup routines. While less realistic, it supports straightforward testing and debugging without complex recovery logic.  

Scalability vs. Simplicity  
Our system targets a small number of devices, making it easy to demonstrate the core ideas without scaling optimi-zations. In a real distributed training environment with potentially thousands of GPUs, orchestrating collective operations might require load balancing, parallelization of coordinator logic, and careful consideration of cross-node latency and bandwidth hierarchies.  
By focusing on a simplified scenario, we ensure that the logic remains understandable and debuggable. The tradeoff is that we do not address issues of massive scale or net-work topologies. Scaling up would necessitate more so-phisticated algorithms, hierarchical communicators, and topology-aware placement strategies, increasing both code complexity and the need for more elaborate testing.  

In summary, the design options reflect a constant tension between accuracy and complexity. By choosing simplified transports, memory models, synchronization models, and fault handling strategies, we produce a framework that is easier to understand, extend, and test. However, it diverges from the high-performance, hardware-optimized reality of actual GPU communication libraries. These tradeoffs were intentional and guided by the project’s educational and prototyping objectives rather than production-level perfor-mance or fault tolerance requirements.  

References  
https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/usage/operations.html  
https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/api/comms.html  
https://grpc.io/docs/  
https://github.com/grpc/grpc/tree/master/examples  
https://protobuf.dev  
https://developer.nvidia.com/blog/gpu-pro-tip-cuda-7-streams-simplify-concurrency/  
https://github.com/facebookincubator/gloo/blob/main/docs/algorithms.md#allreduce_ring  
https://proceedings.mlsys.org/paper_files/paper/2020/file/cd3a9a55f7f3723133fa4a13628cdf03-Paper.pdf  
https://pytorch.org/tutorials/beginner/blitz/neural_networks_tutorial.html  
https://www.tensorflow.org/tutorials/quickstart/beginner  


To run the main.go in cmd/client:    
    1. start the coordinator service  
        go run cmd/gpu_coordinator_main/main.go --port=60050  
    2. start the gpu device service  
        sudo go run cmd/gpu_device/main.go --device_id=1 --rank=0 --port=50050  
        sudo go run cmd/gpu_device/main.go --device_id=2 --rank=1 --port=50050  
        sudo go run cmd/gpu_device/main.go --device_id=3 --rank=2 --port=50050  
    3. run the client   
        sudo go run cmd/client/main.go --coordinator=localhost:60050  

To run integration tests, run   
    sudo go test ./dsml -run TestIntegration -v  
    
