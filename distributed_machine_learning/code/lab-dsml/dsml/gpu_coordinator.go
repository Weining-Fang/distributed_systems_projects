package dsml 

import (
	"context"
	"sync"
	"fmt"
	"log"
	"math"
	// "math/rand"
	"time"
	"io"
	"encoding/binary"
	"google.golang.org/grpc/status"
    "google.golang.org/grpc/codes"
	// "google.golang.org/grpc"
	pb "lab-dsml/proto" // Import the generated protobuf package
	client "lab-dsml/client"
)

type Device struct {
	Metadata		*pb.DeviceMetadata
	Assigned		bool
	CurrentComm		uint64
}

type Communicator struct {
	Devices 		[]*Device
	RankMapping		map[uint32]*Device 
	Status			pb.Status 
}

type GPUCoordinatorService struct {
	pb.UnimplementedGPUCoordinatorServer

	mu					sync.Mutex
	commStatus 			map[uint64]pb.Status
	availableDevices  	[]*Device
	communicators		map[uint64]*Communicator
	nextCommID			uint64

	streamIDCounter  uint64
    streamIDMutex    sync.Mutex

}

func (s *GPUCoordinatorService) generateUniqueStreamID() uint64 {
    s.streamIDMutex.Lock()
    defer s.streamIDMutex.Unlock()
    s.streamIDCounter++
    return s.streamIDCounter
}

func NewGPUCoordinatorService(initialDevices []*pb.DeviceMetadata) *GPUCoordinatorService {
	devices := make([]*Device, len(initialDevices))
	for i, metadata := range initialDevices {
		devices[i] = &Device{
			// Metadata: metadata,
			Metadata: &pb.DeviceMetadata{
                DeviceId:   metadata.DeviceId,
                MinMemAddr: &pb.MemAddr{Value: 0x1000 * uint64(i+1)}, // Unique range
                MaxMemAddr: metadata.MaxMemAddr,
                Rank:       metadata.Rank,
            },
			Assigned: false,
			CurrentComm: 0,
		}
	}
	return &GPUCoordinatorService{
		availableDevices: devices,
		communicators: make(map[uint64]*Communicator),

		commStatus: make(map[uint64]pb.Status),
		nextCommID: 1, // Start communicator IDs from 1
	}
}

// withTimeout returns a context with a 5-second timeout for RPC calls.
func withTimeout(ctx context.Context) (context.Context, context.CancelFunc) {
    return context.WithTimeout(ctx, 5*time.Second)
}


func (s *GPUCoordinatorService) CommInit(ctx context.Context, req *pb.CommInitRequest) (*pb.CommInitResponse, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	n_device_requested := req.GetNumDevices()

	available := 0
	for _, device := range s.availableDevices {
		if !device.Assigned {
			available++
		}
	}

	if uint32(available) < n_device_requested {
		return &pb.CommInitResponse{
			Success: false,
		}, fmt.Errorf("not enough devices available: requested %d, available %d", n_device_requested, available)
	
	}

	selected_devices := []*Device{}
	for i, device := range s.availableDevices {
		if !device.Assigned {
			selected_devices = append(selected_devices, device)
			s.availableDevices[i].Assigned = true 
			s.availableDevices[i].CurrentComm = s.nextCommID 
			if uint32(len(selected_devices)) == n_device_requested {
				break
			}
		}
	}

	devicesMetadata := make([]*pb.DeviceMetadata, n_device_requested)
	rankMapping := make(map[uint32]*Device)

	for i, device := range selected_devices {
		devicesMetadata[i] = &pb.DeviceMetadata{
			DeviceId: 		device.Metadata.DeviceId,
			MinMemAddr: 	device.Metadata.MinMemAddr,
			MaxMemAddr: 	device.Metadata.MaxMemAddr,
			Rank:			&pb.Rank{Value: uint32(i)},
		}
		rankMapping[uint32(i)] = device 
	}

	commId := s.nextCommID
	s.nextCommID++

	s.communicators[commId] = &Communicator{
		Devices: selected_devices,
		RankMapping: rankMapping,
		Status: pb.Status_IN_PROGRESS,
	}
	s.commStatus[commId] = pb.Status_IN_PROGRESS
	fmt.Printf("CommInit: Initialized communication with %d devices (CommId: %d)\n", n_device_requested, commId)
	return &pb.CommInitResponse{
		Success: true,
		CommId: commId,
		Devices: devicesMetadata,
	}, nil
}

func (s *GPUCoordinatorService) CommFinalize(ctx context.Context, req *pb.CommFinalizeRequest) (*pb.CommFinalizeResponse, error) {
	s.mu.Lock()
    defer s.mu.Unlock()
 
    commId := req.GetCommId()
	comm, exists := s.communicators[commId]
	if !exists {
		return &pb.CommFinalizeResponse{
			Success: false,
		}, fmt.Errorf("communicator %d does not exist", commId)
	}

	// Release devices
    for _, device := range comm.Devices {
        device.Assigned = false
        device.CurrentComm = 0
    }

	comm.Status = pb.Status_SUCCESS
	s.communicators[commId].Status = pb.Status_SUCCESS

	delete(s.communicators, commId)

	fmt.Printf("CommFinalize: Finalized communicator %d and released %d devices\n", commId, len(comm.Devices))
	return &pb.CommFinalizeResponse{
		Success: true,
	}, nil 

}

func (s *GPUCoordinatorService) CommDestroy(ctx context.Context, req *pb.CommDestroyRequest) (*pb.CommDestroyResponse, error) {
	s.mu.Lock()
    defer s.mu.Unlock()

	commId := req.GetCommId()
	comm, exists := s.communicators[commId]

	if !exists {
		return &pb.CommDestroyResponse{
			Success: false,
		}, fmt.Errorf("communicator %d does not exist", commId)
	}

	// Optionally, handle ongoing operations: abort data transfers, terminate streams, etc.


	// Release devices
	for _, device := range comm.Devices {
		device.Assigned = false 
		device.CurrentComm = 0 
	}

	comm.Status = pb.Status_FAILED
	s.commStatus[commId] = pb.Status_FAILED

	delete(s.communicators, commId)
	fmt.Printf("CommDestroy: Destroyed communicator %d and released %d devices\n", commId, len(comm.Devices))

	return &pb.CommDestroyResponse{
		Success: true,
	}, nil

}


func (s *GPUCoordinatorService) GetCommStatus(ctx context.Context, req *pb.GetCommStatusRequest) (*pb.GetCommStatusResponse, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	status, ok := s.commStatus[req.GetCommId()]
	if !ok {
		return &pb.GetCommStatusResponse{Status: pb.Status_FAILED}, nil 
	}
	return &pb.GetCommStatusResponse{Status: status}, nil
}

func (s *GPUCoordinatorService) GroupStart(ctx context.Context, req *pb.GroupStartRequest) (*pb.GroupStartResponse, error) {
	fmt.Printf("Received GroupStart request for CommId: %d\n", req.GetCommId())

	// Validate CommId
	if _, exists := s.commStatus[req.GetCommId()]; !exists {
		fmt.Printf("CommId %d not found\n", req.GetCommId())
		return &pb.GroupStartResponse{Success: false}, nil
	}

	// Mark group operation as started
	s.commStatus[req.GetCommId()] = pb.Status_IN_PROGRESS
	fmt.Printf("Group operation started for CommId: %d\n", req.GetCommId())

	return &pb.GroupStartResponse{Success: true}, nil
}

func (s *GPUCoordinatorService) GroupEnd(ctx context.Context, req *pb.GroupEndRequest) (*pb.GroupEndResponse, error) {
	fmt.Printf("Received GroupEnd request for CommId: %d\n", req.GetCommId())

	// Validate CommId
	if _, exists := s.commStatus[req.GetCommId()]; !exists {
		fmt.Printf("CommId %d not found\n", req.GetCommId())
		return &pb.GroupEndResponse{Success: false}, nil
	}

	// Mark group operation as ended
	s.commStatus[req.GetCommId()] = pb.Status_SUCCESS
	fmt.Printf("Group operation ended for CommId: %d\n", req.GetCommId())

	return &pb.GroupEndResponse{Success: true}, nil
}

func (s *GPUCoordinatorService) AllReduceRing(ctx context.Context, req *pb.AllReduceRingRequest) (*pb.AllReduceRingResponse, error) {
	fmt.Printf("Received AllReduceRing request for CommId: %d, Count: %d, Op: %s\n", req.GetCommId(), req.GetCount(), req.GetOp())

	// Validate CommId
	s.mu.Lock()
	commId := req.GetCommId()
	comm, exists := s.communicators[commId]
	if !exists {
		s.mu.Unlock()
		fmt.Printf("AllReduceRing: Communicator %d does not exist\n", commId)
		return &pb.AllReduceRingResponse{Success: false}, fmt.Errorf("communicator %d does not exist", commId)
	}

	if comm.Status != pb.Status_IN_PROGRESS {
		s.mu.Unlock()
		fmt.Printf("AllReduceRing: Communicator %d is not in progress\n", commId)
		return &pb.AllReduceRingResponse{Success: false}, fmt.Errorf("communicator %d is not in progress", commId)
	}

	comm.Status = pb.Status_IN_PROGRESS
	s.mu.Unlock()

	// Determine the ring order based on ranks
	numDevices := len(comm.Devices)
	for i := 0; i < numDevices; i++ {
		srcRank := uint32(i)
		dstRank := uint32((i + 1) % numDevices)

		srcDevice := comm.RankMapping[srcRank]
		dstDevice := comm.RankMapping[dstRank]

		// Define memory addresses (for simulation, using minMemAddr)
		srcMemAddrEntry, srcExists := req.GetMemAddrs()[srcRank]
		dstMemAddrEntry, dstExists := req.GetMemAddrs()[dstRank]
		if !srcExists || !dstExists {
			log.Printf("AllReduceRing: Missing MemAddr for rank %d or %d\n", srcRank, dstRank)
			s.markCommunicatorFailed(commId)
			return &pb.AllReduceRingResponse{Success: false}, fmt.Errorf("missing MemAddr for rank %d or %d", srcRank, dstRank)
		}
		srcMemAddr := srcMemAddrEntry.GetValue()
		dstMemAddr := dstMemAddrEntry.GetValue()

		// ctxWithTimeout, cancel := withTimeout(ctx)
        // defer cancel()

		// Initialize a client for the source device
        srcClient, err := client.NewClient(fmt.Sprintf("localhost:%d", srcDevice.Metadata.GetDeviceId().GetValue()+50050)) // port offset
        if err != nil {
            fmt.Printf("AllReduceRing: Failed to create client for DeviceId %d: %v\n", srcDevice.Metadata.GetDeviceId().GetValue(), err)
            s.markCommunicatorFailed(commId)
            return &pb.AllReduceRingResponse{Success: false}, err
        }
        defer srcClient.Close()

		// Initiate BeginSend on source device
		beginSendResp, err := srcClient.BeginSend(ctx, srcMemAddr, req.GetCount(), dstRank)
		if err != nil {
			fmt.Printf("AllReduceRing: BeginSend failed for StreamId %d: %v\n", beginSendResp.GetStreamId().GetValue(), err)
			s.markCommunicatorFailed(commId)
			return &pb.AllReduceRingResponse{Success: false}, err
		}

		streamID := beginSendResp.GetStreamId().GetValue()

		// Initialize a client for the destination device
        dstClient, err := client.NewClient(fmt.Sprintf("localhost:%d", dstDevice.Metadata.DeviceId.Value+50050)) // Adjust port offset
        if err != nil {
            fmt.Printf("AllReduceRing: Failed to create client for DeviceId %d: %v\n", dstDevice.Metadata.GetDeviceId().GetValue(), err)
            s.markCommunicatorFailed(commId)
            return &pb.AllReduceRingResponse{Success: false}, err
        }
        defer dstClient.Close()

		// Initiate BeginReceive on destination device
        _, err = dstClient.BeginReceive(ctx, streamID, dstMemAddr, req.GetCount(), srcRank)
        if err != nil {
            fmt.Printf("AllReduceRing: BeginReceive failed for StreamId %d: %v\n", streamID, err)
            s.markCommunicatorFailed(commId)
            return &pb.AllReduceRingResponse{Success: false}, err
        }

		// Generate data based on ReduceOp
        data := generateData(req.GetOp(), req.GetCount())

		// Perform StreamSend from coordinator to source device
        err = srcClient.StreamSend(ctx, streamID, srcMemAddr, data)
        if err != nil {
            fmt.Printf("AllReduceRing: StreamSend failed for StreamId %d: %v\n", streamID, err)
            s.markCommunicatorFailed(commId)
            return &pb.AllReduceRingResponse{Success: false}, err
        }
	}

	// After the ring steps, perform the actual reduction logic:
    // 1. Retrieve data from all devices (MemcpyDeviceToHost)
    // 2. Reduce data based on req.GetOp()
    // 3. Write final result back to all devices (MemcpyHostToDevice)
    err := s.performReduction(ctx, comm, req.GetCount(), req.GetOp(), req.GetMemAddrs())
    if err != nil {
        s.markCommunicatorFailed(commId)
        return &pb.AllReduceRingResponse{Success: false}, err
    }

	// Simulate operation delay (for demonstration purposes)
	// time.Sleep(2 * time.Second)

	// Update communicator status to SUCCESS
	s.mu.Lock()
	comm.Status = pb.Status_SUCCESS
	s.commStatus[commId] = pb.Status_SUCCESS
	s.mu.Unlock()

	fmt.Printf("AllReduceRing: Completed AllReduceRing operation for CommId: %d\n", commId)
	return &pb.AllReduceRingResponse{Success: true}, nil

}


func (s *GPUCoordinatorService) Memcpy(ctx context.Context, req *pb.MemcpyRequest) (*pb.MemcpyResponse, error) {
	switch req.GetEither().(type) {
	case *pb.MemcpyRequest_HostToDevice:
		// Handle Host-to-Device transfer
		log.Printf("Memcpy HostToDevice: Data size = %d bytes, Destination DeviceId = %d, Destination MemAddr = 0x%x\n",
			len(req.GetHostToDevice().GetHostSrcData()), req.GetHostToDevice().GetDstDeviceId().GetValue(), req.GetHostToDevice().GetDstMemAddr().GetValue())

		
		// Ensure address is within range
		dstDeviceId := req.GetHostToDevice().GetDstDeviceId().GetValue()
		for _, device := range s.availableDevices {
			if device.Metadata.DeviceId.GetValue() == dstDeviceId {
				if req.GetHostToDevice().GetDstMemAddr().GetValue() < device.Metadata.MinMemAddr.GetValue() ||
				req.GetHostToDevice().GetDstMemAddr().GetValue() > device.Metadata.MaxMemAddr.GetValue() {
					return nil, fmt.Errorf("Memcpy: Invalid memory address 0x%x for device %d", req.GetHostToDevice().GetDstMemAddr().GetValue(), dstDeviceId)
				}
			}
		}
		
		// Initialize a client for the destination GPU device
		dstClient, err := client.NewClient(fmt.Sprintf("localhost:%d", req.GetHostToDevice().GetDstDeviceId().GetValue()+50050)) // Adjust port as needed
		if err != nil {
			log.Printf("Memcpy HostoDevice: Failed to create client for DeviceId %d: %v\n", req.GetHostToDevice().GetDstDeviceId().GetValue(), err)
			return &pb.MemcpyResponse{
				Either: &pb.MemcpyResponse_HostToDevice{
					HostToDevice: &pb.MemcpyHostToDeviceResponse{Success: false},
				},
			}, err
		}
		defer dstClient.Close()

		// Initiate BeginSend on destination device
		// srcRank := uint32(0) // Adjust based on your communicator's rank mapping
		dstRank := req.GetHostToDevice().GetDstDeviceId().GetValue() // Or another appropriate value

		beginSendResp, err := dstClient.BeginSend(ctx, req.GetHostToDevice().GetDstMemAddr().GetValue(), uint64(len(req.GetHostToDevice().GetHostSrcData())), uint32(dstRank))
		if err != nil {
			log.Printf("Memcpy HostToDevice: BeginSend failed: %v\n", err)
			return &pb.MemcpyResponse{
				Either: &pb.MemcpyResponse_HostToDevice{
					HostToDevice: &pb.MemcpyHostToDeviceResponse{Success: false},
				},
			}, err
		}
		streamID := beginSendResp.GetStreamId().GetValue()

		// Perform StreamSend to transfer data to GPU device
		err = dstClient.StreamSend(ctx, streamID, req.GetHostToDevice().GetDstMemAddr().GetValue(), req.GetHostToDevice().GetHostSrcData())
		if err != nil {
			log.Printf("Memcpy HostToDevice: StreamSend failed for StreamId %d: %v\n", streamID, err)
			return &pb.MemcpyResponse{
				Either: &pb.MemcpyResponse_HostToDevice{
					HostToDevice: &pb.MemcpyHostToDeviceResponse{Success: false},
				},
			}, err
		}

		log.Printf("Memcpy HostToDevice: Successfully transferred %d bytes to DeviceId %d at MemAddr 0x%x\n",
			len(req.GetHostToDevice().GetHostSrcData()), req.GetHostToDevice().GetDstDeviceId().GetValue(), req.GetHostToDevice().GetDstMemAddr().GetValue())

		return &pb.MemcpyResponse{
			Either: &pb.MemcpyResponse_HostToDevice{
				HostToDevice: &pb.MemcpyHostToDeviceResponse{Success: true},
			},
		}, nil

	case *pb.MemcpyRequest_DeviceToHost:
		// Handle Device-to-Host transfer
		log.Printf("Memcpy DeviceToHost: Source DeviceId = %d, Source MemAddr = 0x%x, NumBytes = %d\n",
			req.GetDeviceToHost().GetSrcDeviceId().GetValue(), req.GetDeviceToHost().GetSrcMemAddr().GetValue(), req.GetDeviceToHost().GetNumBytes())

		// Initialize a client for the source GPU device
		srcClient, err := client.NewClient(fmt.Sprintf("localhost:%d", req.GetDeviceToHost().GetSrcDeviceId().GetValue()+50050)) // Adjust port as needed
		if err != nil {
			log.Printf("Memcpy DeviceToHost: Failed to create client for DeviceId %d: %v\n", req.GetDeviceToHost().GetSrcDeviceId().GetValue(), err)
			return &pb.MemcpyResponse{
				Either: &pb.MemcpyResponse_DeviceToHost{
					DeviceToHost: &pb.MemcpyDeviceToHostResponse{DstData: nil},
				},
			}, err
		}
		defer srcClient.Close()

		// Generate a unique StreamId for the receive operation
		streamID := s.generateUniqueStreamID()

		// Initiate StreamReceive on source device
		receiveReq := &pb.StreamReceiveRequest{
			StreamId:    &pb.StreamId{Value: streamID},
			RecvBuffAddr: &pb.MemAddr{Value: req.GetDeviceToHost().GetSrcMemAddr().GetValue()},
			NumBytes:    req.GetDeviceToHost().GetNumBytes(),
		}

		streamRecv, err := srcClient.StreamReceive(ctx, receiveReq)
		if err != nil {
			log.Printf("Memcpy DeviceToHost: StreamReceive RPC failed: %v\n", err)
			return &pb.MemcpyResponse{
				Either: &pb.MemcpyResponse_DeviceToHost{
					DeviceToHost: &pb.MemcpyDeviceToHostResponse{DstData: nil},
				},
			}, err
		}

		// Collect the data chunks
		var receivedData []byte
		for {
			chunk, err := streamRecv.Recv()
			if err == io.EOF {
				// Stream has ended successfully
				break
			}
			if err != nil {
				log.Printf("Memcpy DeviceToHost: Error receiving data: %v\n", err)
				return &pb.MemcpyResponse{
					Either: &pb.MemcpyResponse_DeviceToHost{
						DeviceToHost: &pb.MemcpyDeviceToHostResponse{DstData: nil},
					},
				}, err
			}
			receivedData = append(receivedData, chunk.GetData()...)
		}

		log.Printf("Memcpy DeviceToHost: Successfully retrieved %d bytes from DeviceId %d at MemAddr 0x%x\n",
			len(receivedData), req.GetDeviceToHost().GetSrcDeviceId().GetValue(), req.GetDeviceToHost().GetSrcMemAddr().GetValue())

		return &pb.MemcpyResponse{
			Either: &pb.MemcpyResponse_DeviceToHost{
				DeviceToHost: &pb.MemcpyDeviceToHostResponse{DstData: receivedData},
			},
		}, nil

	default:
		// Unknown or unrecognized case
		return nil, status.Errorf(codes.InvalidArgument, "Invalid MemcpyRequest type")
	}
}

func generateData(op pb.ReduceOp, count uint64) []byte {
    data := make([]byte, count*8) // Assuming float64 (8 bytes) per element
    for i := 0; i < int(count); i++ {
        val := float64(1.0) // Example value
        binary.LittleEndian.PutUint64(data[i*8:(i+1)*8], math.Float64bits(val))
    }
    return data
}

// performReduction retrieves the data from all devices, performs the requested reduction operation,
// and writes the final result back to all devices.
func (s *GPUCoordinatorService) performReduction(ctx context.Context, comm *Communicator, count uint64, op pb.ReduceOp, memAddrs map[uint32]*pb.MemAddr) error {
    elementCount := int(count)
    numDevices := len(comm.Devices)
    dataSize := elementCount * 8 // size of float64 * count

    // Retrieve data from each device
    allData := make([][]byte, numDevices)
    for rank, device := range comm.RankMapping {
        ctxWithTimeout, cancel := withTimeout(ctx)
        defer cancel()

        srcDeviceId := device.Metadata.GetDeviceId().GetValue()
        srcMemAddr := memAddrs[rank].GetValue()

        req := &pb.MemcpyRequest{
            Either: &pb.MemcpyRequest_DeviceToHost{
                DeviceToHost: &pb.MemcpyDeviceToHostRequest{
                    SrcDeviceId: &pb.DeviceId{Value: srcDeviceId},
                    SrcMemAddr:  &pb.MemAddr{Value: srcMemAddr},
                    NumBytes:    uint64(dataSize),
                },
            },
        }

        resp, err := s.Memcpy(ctxWithTimeout, req)
        if err != nil {
            log.Printf("performReduction: DeviceToHost Memcpy failed for DeviceId %d: %v", srcDeviceId, err)
            return err
        }

        allData[rank] = resp.GetDeviceToHost().GetDstData()
        if len(allData[rank]) < dataSize {
            return fmt.Errorf("performReduction: insufficient data retrieved from DeviceId %d", srcDeviceId)
        }
    }

    // Allocate a buffer for the final result
    finalData := make([]byte, dataSize)
    // Initialize finalData with the first device's data
    copy(finalData, allData[0])

    // Reduce all arrays into finalData
    for i := 1; i < numDevices; i++ {
        reduceArrays(finalData, allData[i], op)
    }

    // Write final result back to all devices
    for rank, device := range comm.RankMapping {
        ctxWithTimeout, cancel := withTimeout(ctx)
        defer cancel()

        dstDeviceId := device.Metadata.GetDeviceId().GetValue()
        dstMemAddr := memAddrs[rank].GetValue()

        req := &pb.MemcpyRequest{
            Either: &pb.MemcpyRequest_HostToDevice{
                HostToDevice: &pb.MemcpyHostToDeviceRequest{
                    HostSrcData: finalData,
                    DstDeviceId: &pb.DeviceId{Value: dstDeviceId},
                    DstMemAddr:  &pb.MemAddr{Value: dstMemAddr},
                },
            },
        }

        resp, err := s.Memcpy(ctxWithTimeout, req)
        if err != nil || !resp.GetHostToDevice().GetSuccess() {
            return fmt.Errorf("performReduction: HostToDevice Memcpy failed for DeviceId %d: %v", dstDeviceId, err)
        }
    }

    return nil
}

// reduceArrays applies the reduction operation (SUM, PROD, MIN, MAX) element-wise on finalData using inputData.
func reduceArrays(finalData, inputData []byte, op pb.ReduceOp) {
    elementCount := len(finalData) / 8
    for i := 0; i < elementCount; i++ {
        finalVal := math.Float64frombits(binary.LittleEndian.Uint64(finalData[i*8 : i*8+8]))
        inputVal := math.Float64frombits(binary.LittleEndian.Uint64(inputData[i*8 : i*8+8]))

        var outVal float64
        switch op {
        case pb.ReduceOp_SUM:
            outVal = finalVal + inputVal
        case pb.ReduceOp_PROD:
            outVal = finalVal * inputVal
        case pb.ReduceOp_MIN:
            if inputVal < finalVal {
                outVal = inputVal
            } else {
                outVal = finalVal
            }
        case pb.ReduceOp_MAX:
            if inputVal > finalVal {
                outVal = inputVal
            } else {
                outVal = finalVal
            }
        default:
            // If an unknown op is given, default to SUM
            outVal = finalVal + inputVal
        }

        binary.LittleEndian.PutUint64(finalData[i*8:(i+1)*8], math.Float64bits(outVal))
    }
}

func (s *GPUCoordinatorService) markCommunicatorFailed(commId uint64) {
    s.mu.Lock()
    defer s.mu.Unlock()
    if comm, exists := s.communicators[commId]; exists {
        comm.Status = pb.Status_FAILED
        s.commStatus[commId] = pb.Status_FAILED
        // Release devices
        for _, device := range comm.Devices {
            device.Assigned = false
            device.CurrentComm = 0
        }
        delete(s.communicators, commId)
    }
    log.Printf("Communicator %d marked as FAILED and resources released.\n", commId)
}