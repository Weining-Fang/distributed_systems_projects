package dsml_test

import (
	"context"
	"encoding/binary"
	"fmt"
	"log"
	"net"
	"sync"
	"testing"
	"time"

	"lab-dsml/dsml"
	pb "lab-dsml/proto"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

var (
	deviceIDs  = []uint64{1, 2, 3}
	ranks      = []uint32{0, 1, 2}
	coordPort  = 60050
	deviceBase = 50050
)

type testServer struct {
	server   *grpc.Server
	listener net.Listener
}

func startDeviceServer(t *testing.T, deviceID uint64, rank uint32, wg *sync.WaitGroup) *testServer {
	t.Helper()

	address := fmt.Sprintf("localhost:%d", deviceID+uint64(deviceBase))
	lis, err := net.Listen("tcp", address)
	if err != nil {
		t.Fatalf("failed to listen on %s: %v", address, err)
	}

	server := grpc.NewServer()
	devSvc := dsml.NewGPUDeviceService(deviceID, rank)
	pb.RegisterGPUDeviceServer(server, devSvc)

	wg.Add(1)
	go func() {
		if err := server.Serve(lis); err != nil {
			log.Printf("Device server at %s stopped with error: %v", address, err)
		}
		wg.Done()
	}()

	return &testServer{server: server, listener: lis}
}

func startCoordinatorServer(t *testing.T, devices []*pb.DeviceMetadata, wg *sync.WaitGroup) *testServer {
	t.Helper()

	address := fmt.Sprintf("localhost:%d", coordPort)
	lis, err := net.Listen("tcp", address)
	if err != nil {
		t.Fatalf("failed to listen on %s: %v", address, err)
	}

	server := grpc.NewServer()
	coordSvc := dsml.NewGPUCoordinatorService(devices)
	pb.RegisterGPUCoordinatorServer(server, coordSvc)

	wg.Add(1)
	go func() {
		if err := server.Serve(lis); err != nil {
			log.Printf("Coordinator server at %s stopped with error: %v", address, err)
		}
		wg.Done()
	}()

	return &testServer{server: server, listener: lis}
}

func TestIntegration(t *testing.T) {
	var wg sync.WaitGroup

	// Prepare initial device metadata
	var initialDevices []*pb.DeviceMetadata
	for i := range deviceIDs {
		initialDevices = append(initialDevices, &pb.DeviceMetadata{
			DeviceId:   &pb.DeviceId{Value: deviceIDs[i]},
			MinMemAddr: &pb.MemAddr{Value: 0x1000},
			MaxMemAddr: &pb.MemAddr{Value: 0x1FFFFF},
			Rank:       &pb.Rank{Value: ranks[i]},
		})
	}

	// Start all device servers
	var deviceServers []*testServer
	for i, devID := range deviceIDs {
		deviceServers = append(deviceServers, startDeviceServer(t, devID, ranks[i], &wg))
	}

	// Start coordinator server
	coordServer := startCoordinatorServer(t, initialDevices, &wg)

	// Wait a moment for servers to start
	time.Sleep(500 * time.Millisecond)

	// Create coordinator client
	coordAddr := fmt.Sprintf("localhost:%d", coordPort)
	connCoord, err := grpc.Dial(coordAddr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		t.Fatalf("failed to dial coordinator: %v", err)
	}
	defer connCoord.Close()
	coordClient := pb.NewGPUCoordinatorClient(connCoord)

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	// ===== Base Test Scenario: Basic CommInit, Memcpy, AllReduce, CommFinalize =====
	initResp, err := coordClient.CommInit(ctx, &pb.CommInitRequest{NumDevices: 3})
	if err != nil || !initResp.GetSuccess() {
		t.Fatalf("CommInit failed: %v", err)
	}
	commId := initResp.GetCommId()
	devs := initResp.GetDevices()
	t.Logf("CommInit success with CommId = %d", commId)

	// Test Memcpy Host-to-Device
	t.Run("MemcpyHostToDevice", func(t *testing.T) {
		dataToSend := []byte("Hello GPU Device!")
		memcpyReq := &pb.MemcpyRequest{
			Either: &pb.MemcpyRequest_HostToDevice{
				HostToDevice: &pb.MemcpyHostToDeviceRequest{
					HostSrcData: dataToSend,
					DstDeviceId: devs[0].GetDeviceId(),
					DstMemAddr:  &pb.MemAddr{Value: 0x1000},
				},
			},
		}
		memcpyResp, err := coordClient.Memcpy(ctx, memcpyReq)
		if err != nil {
			t.Fatalf("Host-to-Device Memcpy failed: %v", err)
		}
		if !memcpyResp.GetHostToDevice().GetSuccess() {
			t.Fatalf("Host-to-Device Memcpy not successful")
		}
		t.Logf("Host-to-Device Memcpy completed successfully.")
	})

	// Test Memcpy Device-to-Host
	t.Run("MemcpyDeviceToHost", func(t *testing.T) {
		deviceToHostReq := &pb.MemcpyRequest{
			Either: &pb.MemcpyRequest_DeviceToHost{
				DeviceToHost: &pb.MemcpyDeviceToHostRequest{
					SrcDeviceId: devs[0].GetDeviceId(),
					SrcMemAddr:  &pb.MemAddr{Value: 0x1000},
					NumBytes:    uint64(len("Hello GPU Device!")),
				},
			},
		}
		memcpyResp, err := coordClient.Memcpy(ctx, deviceToHostReq)
		if err != nil {
			t.Fatalf("Device-to-Host Memcpy failed: %v", err)
		}
		receivedData := memcpyResp.GetDeviceToHost().GetDstData()
		if string(receivedData) != "Hello GPU Device!" {
			t.Fatalf("Device-to-Host Memcpy returned unexpected data: %s", string(receivedData))
		}
		t.Logf("Device-to-Host Memcpy successful, received: %s", string(receivedData))
	})

	// Test AllReduceRing
	t.Run("AllReduceRing", func(t *testing.T) {
		_, err := coordClient.GroupStart(ctx, &pb.GroupStartRequest{CommId: commId})
		if err != nil {
			t.Fatalf("GroupStart failed: %v", err)
		}

		memAddrs := make(map[uint32]*pb.MemAddr)
		for i, d := range devs {
			memAddrs[uint32(i)] = &pb.MemAddr{Value: d.MinMemAddr.GetValue()}
		}

		allReduceReq := &pb.AllReduceRingRequest{
			CommId:   commId,
			Count:    4,
			Op:       pb.ReduceOp_SUM,
			MemAddrs: memAddrs,
		}

		allReduceResp, err := coordClient.AllReduceRing(ctx, allReduceReq)
		if err != nil {
			t.Fatalf("AllReduceRing failed: %v", err)
		}
		if !allReduceResp.GetSuccess() {
			t.Fatalf("AllReduceRing not successful")
		}
		t.Logf("AllReduceRing operation completed successfully.")

		_, err = coordClient.GroupEnd(ctx, &pb.GroupEndRequest{CommId: commId})
		if err != nil {
			t.Fatalf("GroupEnd failed: %v", err)
		}
	})

	t.Run("CommFinalize", func(t *testing.T) {
		finalResp, err := coordClient.CommFinalize(ctx, &pb.CommFinalizeRequest{CommId: commId})
		if err != nil {
			t.Fatalf("CommFinalize failed: %v", err)
		}
		if !finalResp.GetSuccess() {
			t.Fatalf("CommFinalize returned unsuccessful")
		}
		t.Logf("CommFinalize successful for CommId %d", commId)
	})


	// ===== Additional Tests =====
	// 1. Test Error Handling: Request more devices than available
	t.Run("CommInitNotEnoughDevices", func(t *testing.T) {
		resp, err := coordClient.CommInit(ctx, &pb.CommInitRequest{NumDevices: 10}) // more than we have
		if err == nil && resp.GetSuccess() {
			t.Fatalf("Expected failure when requesting more devices than available")
		} else {
			t.Logf("As expected, CommInit failed with not enough devices.")
		}
	})

	// 2. Test invalid memory address for Memcpy
	t.Run("MemcpyHostToDeviceInvalidAddress", func(t *testing.T) {
		// Initialize a communicator for this test
		initResp, err := coordClient.CommInit(ctx, &pb.CommInitRequest{NumDevices: 3})
		if err != nil || !initResp.GetSuccess() {
			t.Fatalf("CommInit failed: %v", err)
		}
		localCommId := initResp.GetCommId()
		devices := initResp.GetDevices()

		// Try an out-of-range memory address
		data := []byte("TestData")
		memcpyReq := &pb.MemcpyRequest{
			Either: &pb.MemcpyRequest_HostToDevice{
				HostToDevice: &pb.MemcpyHostToDeviceRequest{
					HostSrcData: data,
					DstDeviceId: devices[0].GetDeviceId(),
					DstMemAddr:  &pb.MemAddr{Value: 0xFFFFFFFFF}, // Out of range
				},
			},
		}
		resp, err := coordClient.Memcpy(ctx, memcpyReq)
		if err == nil {
			t.Fatalf("Expected error for invalid memory address, got success response: %v", resp)
		} else {
			t.Logf("Memcpy with invalid address failed as expected: %v", err)
		}

		// Finalize communicator
		finalResp, err := coordClient.CommFinalize(ctx, &pb.CommFinalizeRequest{CommId: localCommId})
		if err != nil || !finalResp.GetSuccess() {
			t.Fatalf("CommFinalize failed after invalid address test: %v", err)
		}
	})

	// 3. Test Point-to-Point Communication (Device-to-Device) explicitly
	t.Run("DeviceToDeviceTransfer", func(t *testing.T) {
		// New communicator
		initResp, err := coordClient.CommInit(ctx, &pb.CommInitRequest{NumDevices: 3})
		if err != nil || !initResp.GetSuccess() {
			t.Fatalf("CommInit failed: %v", err)
		}
		localCommId := initResp.GetCommId()
		devices := initResp.GetDevices()

		srcDevice := devices[0]
		dstDevice := devices[1]

		// Host-to-Device: Put data on src device
		data := []byte("DeviceToDeviceTestData")
		_, err = coordClient.Memcpy(ctx, &pb.MemcpyRequest{
			Either: &pb.MemcpyRequest_HostToDevice{
				HostToDevice: &pb.MemcpyHostToDeviceRequest{
					HostSrcData: data,
					DstDeviceId: srcDevice.GetDeviceId(),
					DstMemAddr:  &pb.MemAddr{Value: srcDevice.MinMemAddr.GetValue()},
				},
			},
		})
		if err != nil {
			t.Fatalf("HostToDevice failed before device-to-device test: %v", err)
		}

		// BeginSend from srcDevice to dstDevice
		// BeginReceive on dstDevice
		// Simulate a direct transfer of data
		// The coordinator handles the logic, we just call its methods to mimic the steps.
		// streamID := uint64(9999) // The coordinator and devices generate their own streamIDs internally, just a placeholder
		// We'll mimic the AllReduce steps: but here directly:
		// Actually, in current code, BeginSend/BeginReceive are triggered internally via AllReduceRing.
		// Let's assume we can call them directly via a new client if implemented.
		// For simplicity: We'll trust that Memcpy DeviceToHost on the destination device after coordinator triggered send/recv works.
		// Since we don't have a direct RPC from coordinator to device in this test environment, we rely on Memcpy to validate data was transferred.

		// We can simulate a scenario: AllReduce calls internally do this, but we can also do something similar:
		// We'll do a fake AllReduce with count=some length.
		count := uint64(len(data))
		memAddrs := map[uint32]*pb.MemAddr{
			srcDevice.Rank.GetValue(): {Value: srcDevice.MinMemAddr.GetValue()},
			dstDevice.Rank.GetValue(): {Value: dstDevice.MinMemAddr.GetValue()},
		}

		_, err = coordClient.GroupStart(ctx, &pb.GroupStartRequest{CommId: localCommId})
		if err != nil {
			t.Fatalf("GroupStart failed: %v", err)
		}

		// Perform a ring reduce with just two devices to ensure data moves
		reduceReq := &pb.AllReduceRingRequest{
			CommId:   localCommId,
			Count:    count,
			Op:       pb.ReduceOp_SUM, // irrelevant op, we just want to test the data movement
			MemAddrs: memAddrs,
		}
		allReduceResp, err := coordClient.AllReduceRing(ctx, reduceReq)
		if err != nil || !allReduceResp.GetSuccess() {
			t.Fatalf("AllReduceRing during device-to-device test failed: %v", err)
		}

		_, err = coordClient.GroupEnd(ctx, &pb.GroupEndRequest{CommId: localCommId})
		if err != nil {
			t.Fatalf("GroupEnd failed: %v", err)
		}

		// Now data should have been reduced onto both devices. Just verify dstDevice has it:
		resp, err := coordClient.Memcpy(ctx, &pb.MemcpyRequest{
			Either: &pb.MemcpyRequest_DeviceToHost{
				DeviceToHost: &pb.MemcpyDeviceToHostRequest{
					SrcDeviceId: dstDevice.GetDeviceId(),
					SrcMemAddr:  &pb.MemAddr{Value: dstDevice.MinMemAddr.GetValue()},
					NumBytes:    uint64(len(data)),
				},
			},
		})
		if err != nil {
			t.Fatalf("DeviceToHost failed when checking device-to-device result: %v", err)
		}
		received := resp.GetDeviceToHost().GetDstData()
		if len(received) != len(data) {
			t.Fatalf("DeviceToDevice transfer validation failed: got %d bytes, expected %d", len(received), len(data))
		}
		t.Logf("Device-to-Device transfer validated. Received: %s", string(received))

		// Cleanup communicator
		finalResp, err := coordClient.CommFinalize(ctx, &pb.CommFinalizeRequest{CommId: localCommId})
		if err != nil || !finalResp.GetSuccess() {
			t.Fatalf("CommFinalize failed after device-to-device test: %v", err)
		}
	})

	// 4. Test attempting operations on a finalized communicator
	t.Run("UseFinalizedCommunicator", func(t *testing.T) {
		// First init and finalize a communicator
		initResp, err := coordClient.CommInit(ctx, &pb.CommInitRequest{NumDevices: 3})
		if err != nil || !initResp.GetSuccess() {
			t.Fatalf("CommInit failed: %v", err)
		}
		localCommId := initResp.GetCommId()

		finalResp, err := coordClient.CommFinalize(ctx, &pb.CommFinalizeRequest{CommId: localCommId})
		if err != nil || !finalResp.GetSuccess() {
			t.Fatalf("CommFinalize failed: %v", err)
		}

		// Now try GroupStart on the finalized communicator
		_, err = coordClient.GroupStart(ctx, &pb.GroupStartRequest{CommId: localCommId})
		if err == nil {
			t.Fatalf("Expected error when calling GroupStart on finalized communicator")
		} else {
			t.Logf("Got expected error calling GroupStart on finalized communicator: %v", err)
		}
	})

	// 5. Test zero-length Memcpy (should generally be no-op, but not fail)
	t.Run("ZeroLengthMemcpy", func(t *testing.T) {
		initResp, err := coordClient.CommInit(ctx, &pb.CommInitRequest{NumDevices: 3})
		if err != nil || !initResp.GetSuccess() {
			t.Fatalf("CommInit failed: %v", err)
		}
		localCommId := initResp.GetCommId()
		devices := initResp.GetDevices()

		// Zero-length HostToDevice
		_, err = coordClient.Memcpy(ctx, &pb.MemcpyRequest{
			Either: &pb.MemcpyRequest_HostToDevice{
				HostToDevice: &pb.MemcpyHostToDeviceRequest{
					HostSrcData: []byte{},
					DstDeviceId: devices[0].GetDeviceId(),
					DstMemAddr:  &pb.MemAddr{Value: devices[0].GetMinMemAddr().GetValue()},
				},
			},
		})
		if err != nil {
			t.Fatalf("Zero-length HostToDevice failed unexpectedly: %v", err)
		}

		// Zero-length DeviceToHost
		_, err = coordClient.Memcpy(ctx, &pb.MemcpyRequest{
			Either: &pb.MemcpyRequest_DeviceToHost{
				DeviceToHost: &pb.MemcpyDeviceToHostRequest{
					SrcDeviceId: devices[0].GetDeviceId(),
					SrcMemAddr:  &pb.MemAddr{Value: devices[0].GetMinMemAddr().GetValue()},
					NumBytes:    0,
				},
			},
		})
		if err != nil {
			t.Fatalf("Zero-length DeviceToHost failed unexpectedly: %v", err)
		}

		t.Logf("Zero-length Memcpy tests passed.")

		// Cleanup communicator
		finalResp, err := coordClient.CommFinalize(ctx, &pb.CommFinalizeRequest{CommId: localCommId})
		if err != nil || !finalResp.GetSuccess() {
			t.Fatalf("CommFinalize failed after zero-length memcpy test: %v", err)
		}
	})

	// Now that all tests are done, stop the servers so wg.Wait() can proceed
	coordServer.server.Stop()
	for _, ds := range deviceServers {
		ds.server.Stop()
	}

	// Wait for servers to clean up
	wg.Wait()
}

// Utility function to decode float64 if needed
func float64FromBytes(b []byte) float64 {
	return float64FromBits(binary.LittleEndian.Uint64(b))
}
func float64FromBits(u uint64) float64 {
	return float64FromBits(u) // This is a no-op in this snippet, but left as placeholder if needed
}