package dsml

import (
    "context"
    "fmt"
    // "math/rand"
    "sync"
    // "time"
	"io"
	"encoding/binary"
	"log"
	"google.golang.org/grpc/status"
    "google.golang.org/grpc/codes"
	"google.golang.org/grpc"
    pb "lab-dsml/proto" // Import generated protobuf package
)


// GPUDeviceService implements the GPUDevice service
type GPUDeviceService struct {
    pb.UnimplementedGPUDeviceServer
    DeviceId   uint64
    MinMemAddr uint64
    MaxMemAddr uint64
	Rank	   uint32 
    streams    sync.Map
	memory 	   sync.Map // map[memAddr]byte[]

	streamIDCounter  uint64
    streamIDMutex    sync.Mutex
	
}

func NewGPUDeviceService(deviceId uint64, rank uint32) *GPUDeviceService {
    // rand.Seed(time.Now().UnixNano())
    return &GPUDeviceService{
        DeviceId:   deviceId,//rand.Uint64(),
        MinMemAddr: 0x1000,
        MaxMemAddr: 0x100000,
		Rank:		rank,
        streams:    sync.Map{},
		memory:		sync.Map{},
    }
}

func (s *GPUDeviceService) GetDeviceMetadata(ctx context.Context, req *pb.GetDeviceMetadataRequest) (*pb.GetDeviceMetadataResponse, error) {
	return &pb.GetDeviceMetadataResponse{
		Metadata: &pb.DeviceMetadata {
			DeviceId: &pb.DeviceId{Value: s.DeviceId},
			MinMemAddr: &pb.MemAddr{Value: s.MinMemAddr},
			MaxMemAddr: &pb.MemAddr{Value: s.MaxMemAddr},
			Rank: &pb.Rank{Value: s.Rank},
		},
		
	}, nil
}

func (s *GPUDeviceService) generateUniqueStreamID() uint64 {
    s.streamIDMutex.Lock()
    defer s.streamIDMutex.Unlock()
    s.streamIDCounter++
    return s.streamIDCounter
}


// BeginSend starts a non-blocking send operation.
func (s *GPUDeviceService) BeginSend(ctx context.Context, req *pb.BeginSendRequest) (*pb.BeginSendResponse, error) {
	streamID := s.generateUniqueStreamID()
    s.streams.Store(streamID, pb.Status_IN_PROGRESS)

	fmt.Printf("BeginSend: Stream %d started\n", streamID)

	return &pb.BeginSendResponse{
		Initiated: true,
		StreamId: &pb.StreamId{Value: streamID},
	}, nil
}

// BeginReceive starts a non-blocking receive operation.
func (s *GPUDeviceService) BeginReceive(ctx context.Context, req *pb.BeginReceiveRequest) (*pb.BeginReceiveResponse, error) {
	streamID := req.GetStreamId().GetValue()
	s.streams.Store(streamID, pb.Status_IN_PROGRESS)
	fmt.Printf("BeginReceive: Stream %d ready to receive %d bytes from rank %d\n", req.GetStreamId().GetValue(), req.GetNumBytes(), req.GetSrcRank().GetValue())	
	return &pb.BeginReceiveResponse{
		Initiated: true,

	}, nil 
}


// 1.	First 8 Bytes: StreamId (uint64, little endian)
// 2.	Next 8 Bytes: MemAddr (uint64, little endian)
// 3.	Remaining Bytes: Actual data payload

func (s *GPUDeviceService) StreamSend(stream grpc.ClientStreamingServer[pb.DataChunk, pb.StreamSendResponse]) error {
    firstChunk, err := stream.Recv()
    if err != nil {
        return status.Errorf(codes.Internal, "StreamSend: failed to receive initial data chunk: %v", err)
    }

    if len((firstChunk).GetData()) < 16 {
        return status.Errorf(codes.InvalidArgument, "StreamSend: initial data chunk too short")
    }

    // Extract StreamId and MemAddr
    streamID := binary.LittleEndian.Uint64((firstChunk).GetData()[:8])
    memAddr := binary.LittleEndian.Uint64((firstChunk).GetData()[8:16])

    // s.streams.Store(streamID, pb.Status_IN_PROGRESS)
	s.streams.Store(streamID, &[]byte{})
    fmt.Printf("StreamSend: Stream %d started, writing to MemAddr 0x%x\n", streamID, memAddr)

    // Step 2: Store incoming data
    var totalBytes int64
    for {
        chunk, err := stream.Recv()
        if err == io.EOF {
			bufferValue, ok := s.streams.LoadAndDelete(streamID)
            if !ok {
                return status.Errorf(codes.Internal, "StreamSend: failed to retrieve buffer for StreamId %d", streamID)
            }

            buffer := *(bufferValue.(*[]byte))

            // Write the accumulated data to the memory map
            s.memory.Store(memAddr, buffer)
            s.streams.Store(streamID, pb.Status_SUCCESS)

            fmt.Printf("StreamSend: Stream %d completed, total bytes received: %d\n", streamID, totalBytes)
            response := &pb.StreamSendResponse{Success: true}
            return stream.SendAndClose(response)

            // Stream ends successfully
            // s.streams.Store(streamID, pb.Status_SUCCESS)
            // fmt.Printf("StreamSend: Stream %d completed, total bytes received: %d\n", streamID, totalBytes)
			// response := &pb.StreamSendResponse{Success: true}
			// return stream.SendAndClose(response)
        }
        if err != nil {
            s.streams.Store(streamID, pb.Status_FAILED)
            return status.Errorf(codes.Internal, "StreamSend: failed to receive chunk: %v", err)
        }

		// Append received chunk to the temporary buffer
        bufferValue, ok := s.streams.Load(streamID)
        if !ok {
            return status.Errorf(codes.Internal, "StreamSend: buffer not found for StreamId %d", streamID)
        }

        buffer := bufferValue.(*[]byte)
        *buffer = append(*buffer, chunk.GetData()...)

        totalBytes += int64(len(chunk.GetData()))
		fmt.Printf("StreamSend: Stream %d received %d bytes\n", streamID, len(chunk.GetData()))

        // Append chunk to memory
        // receivedData := (*chunk).GetData()
        // data, _ := s.memory.LoadOrStore(memAddr, []byte{})
        // updatedData := append(data.([]byte), receivedData...)
        // s.memory.Store(memAddr, updatedData)
        // totalBytes += int64(len(receivedData))
        // fmt.Printf("StreamSend: Stream %d received %d bytes\n", streamID, len(receivedData))
    }
}

func (s *GPUDeviceService) GetStreamStatus(ctx context.Context, req *pb.GetStreamStatusRequest) (*pb.GetStreamStatusResponse, error) {
	streamID := req.GetStreamId().GetValue()
	value, ok := s.streams.Load(streamID)
	if !ok {
		return &pb.GetStreamStatusResponse{Status: pb.Status_FAILED}, nil 
	}
	status, ok2 := value.(pb.Status)
	if !ok2 {
		fmt.Println("GetStreamStatus: Failed to assert stream status")
		return &pb.GetStreamStatusResponse{Status: pb.Status_FAILED}, nil 
	}
	return &pb.GetStreamStatusResponse{Status: status}, nil
}


func (s *GPUDeviceService) StreamReceive(req *pb.StreamReceiveRequest, stream pb.GPUDevice_StreamReceiveServer) error {
    streamID := req.GetStreamId().GetValue()
    memAddr := req.GetRecvBuffAddr().GetValue()
    numBytes := req.GetNumBytes()

    // Retrieve data from memory
    data, ok := s.memory.Load(memAddr)
    if !ok {
        return fmt.Errorf("StreamReceive: memory address 0x%x not found", memAddr)
    }
    dataBytes := data.([]byte)

    // Ensure we don't exceed the requested number of bytes
    if uint64(len(dataBytes)) > numBytes {
        dataBytes = dataBytes[:numBytes]
    }

    // Stream the data back to the coordinator
    chunk := &pb.DataChunk{
        Data: dataBytes,
    }
    if err := stream.Send(chunk); err != nil {
        s.streams.Store(streamID, pb.Status_FAILED)
        return fmt.Errorf("StreamReceive: failed to send data chunk: %v", err)
    }

    // Mark the stream as successful
    s.streams.Store(streamID, pb.Status_SUCCESS)
    log.Printf("StreamReceive: Successfully sent %d bytes for StreamId %d\n", len(dataBytes), streamID)
    return nil
}
