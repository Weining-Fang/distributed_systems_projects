package dsml

import (
    "context"
    "encoding/binary"
    "fmt"
    // "io"

    "google.golang.org/grpc"
    pb "lab-dsml/proto"
)

// GPUDeviceClient wraps the gRPC client and connection for interacting with a single GPUDevice.
type GPUDeviceClient struct {
    conn   *grpc.ClientConn
    client pb.GPUDeviceClient
}

// NewClient creates a new GPUDeviceClient connected to the specified address.
// The address should be something like "localhost:50051" or similar.
func NewClient(address string) (*GPUDeviceClient, error) {
    conn, err := grpc.Dial(address, grpc.WithInsecure())
    if err != nil {
        return nil, fmt.Errorf("failed to connect to %s: %v", address, err)
    }
    client := pb.NewGPUDeviceClient(conn)
    return &GPUDeviceClient{
        conn:   conn,
        client: client,
    }, nil
}

// Close closes the underlying gRPC connection.
func (c *GPUDeviceClient) Close() error {
    return c.conn.Close()
}

// BeginSend initiates a BeginSend RPC on the GPUDevice.
func (c *GPUDeviceClient) BeginSend(ctx context.Context, sendBuffAddr uint64, numBytes uint64, dstRank uint32) (*pb.BeginSendResponse, error) {
    req := &pb.BeginSendRequest{
        SendBuffAddr: &pb.MemAddr{Value: sendBuffAddr},
        NumBytes:     numBytes,
        DstRank:      &pb.Rank{Value: dstRank},
    }
    resp, err := c.client.BeginSend(ctx, req)
    if err != nil {
        return nil, fmt.Errorf("BeginSend RPC failed: %v", err)
    }
    if !resp.GetInitiated() {
        return nil, fmt.Errorf("BeginSend did not initiate successfully")
    }
    return resp, nil
}

// BeginReceive initiates a BeginReceive RPC on the GPUDevice.
func (c *GPUDeviceClient) BeginReceive(ctx context.Context, streamID uint64, recvBuffAddr uint64, numBytes uint64, srcRank uint32) (*pb.BeginReceiveResponse, error) {
    req := &pb.BeginReceiveRequest{
        StreamId:     &pb.StreamId{Value: streamID},
        RecvBuffAddr: &pb.MemAddr{Value: recvBuffAddr},
        NumBytes:     numBytes,
        SrcRank:      &pb.Rank{Value: srcRank},
    }
    resp, err := c.client.BeginReceive(ctx, req)
    if err != nil {
        return nil, fmt.Errorf("BeginReceive RPC failed: %v", err)
    }
    if !resp.GetInitiated() {
        return nil, fmt.Errorf("BeginReceive did not initiate successfully")
    }
    return resp, nil
}

// StreamSend performs the StreamSend RPC to send data from the coordinator (acting as the src device) to the GPU device.
func (c *GPUDeviceClient) StreamSend(ctx context.Context, streamID uint64, memAddr uint64, data []byte) error {
    // Initiate the StreamSend RPC which is a client-side streaming RPC.
    stream, err := c.client.StreamSend(ctx)
    if err != nil {
        return fmt.Errorf("failed to initiate StreamSend RPC: %v", err)
    }

    // Prepare the initial DataChunk with StreamId and MemAddr:
    // First 8 bytes: StreamId (little endian)
    // Next 8 bytes: MemAddr (little endian)
    initialData := make([]byte, 16)
    binary.LittleEndian.PutUint64(initialData[:8], streamID)
    binary.LittleEndian.PutUint64(initialData[8:16], memAddr)
    initialChunk := &pb.DataChunk{
        Data: initialData,
    }

    // Send the initial DataChunk
    if err := stream.Send(initialChunk); err != nil {
        return fmt.Errorf("StreamSend: failed to send initial DataChunk: %v", err)
    }

    // Send the actual data if any
    if len(data) > 0 {
        dataChunk := &pb.DataChunk{
            Data: data,
        }
        if err := stream.Send(dataChunk); err != nil {
            return fmt.Errorf("StreamSend: failed to send data chunk: %v", err)
        }
    }

    // Close the stream and receive the response
    resp, err := stream.CloseAndRecv()
    if err != nil {
        return fmt.Errorf("StreamSend RPC failed: %v", err)
    }
    if !resp.GetSuccess() {
        return fmt.Errorf("StreamSend RPC indicated failure")
    }

    // Successfully completed the StreamSend RPC
    return nil
}

// StreamReceive initiates the StreamReceive RPC on the GPUDevice and returns a client-side stream
// to read incoming DataChunks.
func (c *GPUDeviceClient) StreamReceive(ctx context.Context, req *pb.StreamReceiveRequest) (pb.GPUDevice_StreamReceiveClient, error) {
    // This RPC returns a server-side streaming response.
    // The returned pb.GPUDevice_StreamReceiveClient can be used to Recv() data chunks.
    stream, err := c.client.StreamReceive(ctx, req)
    if err != nil {
        return nil, fmt.Errorf("StreamReceive RPC failed: %v", err)
    }
    return stream, nil
}

// Additional helper methods can be implemented as needed, for example to wrap Memcpy operations or
// to retrieve device metadata.

func (c *GPUDeviceClient) GetDeviceMetadata(ctx context.Context) (*pb.DeviceMetadata, error) {
    req := &pb.GetDeviceMetadataRequest{}
    resp, err := c.client.GetDeviceMetadata(ctx, req)
    if err != nil {
        return nil, fmt.Errorf("GetDeviceMetadata RPC failed: %v", err)
    }
    return resp.GetMetadata(), nil
}

func (c *GPUDeviceClient) GetStreamStatus(ctx context.Context, streamID uint64) (pb.Status, error) {
    req := &pb.GetStreamStatusRequest{
        StreamId: &pb.StreamId{Value: streamID},
    }
    resp, err := c.client.GetStreamStatus(ctx, req)
    if err != nil {
        return pb.Status_FAILED, fmt.Errorf("GetStreamStatus RPC failed: %v", err)
    }
    return resp.GetStatus(), nil
}