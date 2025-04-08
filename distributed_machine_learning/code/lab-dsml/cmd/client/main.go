package main

import (
	"context"
	"flag"
	// "fmt"
	"log"
	"time"

	pb "lab-dsml/proto"
	// client "lab-dsml/client"
	"google.golang.org/grpc"
)

var (
	coordinatorAddress = flag.String("coordinator", "localhost:60050", "Address of the GPUCoordinator service")
)

func main() {
	flag.Parse()

	// Connect to the GPUCoordinator
	log.Printf("Connecting to GPUCoordinator at %s...", *coordinatorAddress)
	conn, err := grpc.Dial(*coordinatorAddress, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("Failed to connect to GPUCoordinator: %v", err)
	}
	defer conn.Close()

	coordinatorClient := pb.NewGPUCoordinatorClient(conn)

	// Step 1: Initialize a communicator
	log.Println("Initializing communicator with 3 devices...")
	initReq := &pb.CommInitRequest{NumDevices: 3}
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	initResp, err := coordinatorClient.CommInit(ctx, initReq)
	if err != nil || !initResp.GetSuccess() {
		log.Fatalf("Failed to initialize communicator: %v", err)
	}
	commId := initResp.GetCommId()
	log.Printf("Communicator initialized with CommId: %d", commId)

	// Display assigned devices
	for _, device := range initResp.GetDevices() {
		log.Printf("DeviceId: %d, Rank: %d, MinMemAddr: 0x%x, MaxMemAddr: 0x%x",
			device.GetDeviceId().GetValue(),
			device.GetRank().GetValue(),
			device.GetMinMemAddr().GetValue(),
			device.GetMaxMemAddr().GetValue(),
		)
	}

	// Step 2: Perform a Memcpy operation (Host-to-Device)
	log.Println("Performing Host-to-Device Memcpy...")
	dataToSend := []byte("Hello GPU Device!")
	hostToDeviceReq := &pb.MemcpyRequest{
		Either: &pb.MemcpyRequest_HostToDevice{
			HostToDevice: &pb.MemcpyHostToDeviceRequest{
				HostSrcData: dataToSend,
				DstDeviceId: initResp.GetDevices()[0].GetDeviceId(),
				DstMemAddr:  &pb.MemAddr{Value: 0x1000},
			},
		},
	}
	memcpyResp, err := coordinatorClient.Memcpy(ctx, hostToDeviceReq)
	if err != nil || !memcpyResp.GetHostToDevice().GetSuccess() {
		log.Fatalf("Host-to-Device Memcpy failed: %v", err)
	}
	log.Println("Host-to-Device Memcpy completed successfully.")

	// Step 3: Perform a Memcpy operation (Device-to-Host)
	log.Println("Performing Device-to-Host Memcpy...")
	deviceToHostReq := &pb.MemcpyRequest{
		Either: &pb.MemcpyRequest_DeviceToHost{
			DeviceToHost: &pb.MemcpyDeviceToHostRequest{
				SrcDeviceId: initResp.GetDevices()[0].GetDeviceId(),
				SrcMemAddr:  &pb.MemAddr{Value: 0x1000},
				NumBytes:    uint64(len(dataToSend)),
			},
		},
	}
	memcpyResp, err = coordinatorClient.Memcpy(ctx, deviceToHostReq)
	if err != nil {
		log.Fatalf("Device-to-Host Memcpy failed: %v", err)
	}
	receivedData := memcpyResp.GetDeviceToHost().GetDstData()
	log.Printf("Device-to-Host Memcpy completed successfully. Data: %s", string(receivedData))

	// Step 4: Finalize the communicator
	log.Println("Finalizing communicator...")
	finalizeReq := &pb.CommFinalizeRequest{CommId: commId}
	_, err = coordinatorClient.CommFinalize(ctx, finalizeReq)
	if err != nil {
		log.Fatalf("Failed to finalize communicator: %v", err)
	}
	log.Println("Communicator finalized successfully.")
}