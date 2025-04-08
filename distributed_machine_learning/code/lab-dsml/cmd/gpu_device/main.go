package main

import (
    "flag"
    "fmt"
    "log"
    "net"
    "os"
    "os/signal"
    "syscall"

    "google.golang.org/grpc"
    pb "lab-dsml/proto"
    "lab-dsml/dsml"
)

var (
    deviceID = flag.Uint64("device_id", 1, "Unique ID for the GPU device")
    rank     = flag.Uint("rank", 0, "Rank of the device")
    port     = flag.Int("port", 50050, "Port number for GPUDevice service")
)

func main() {
    flag.Parse()

    // Create GPUDevice service
    gpuService := dsml.NewGPUDeviceService(*deviceID, uint32(*rank))

    lis, err := net.Listen("tcp", fmt.Sprintf(":%d", *port+int(*deviceID)))
    if err != nil {
        log.Fatalf("Failed to listen on port %d: %v", *port+int(*deviceID), err)
    }

    grpcServer := grpc.NewServer()
    pb.RegisterGPUDeviceServer(grpcServer, gpuService)

    go func() {
        log.Printf("GPUDevice %d (rank %d) listening on port %d", *deviceID, *rank, *port+int(*deviceID))
        if err := grpcServer.Serve(lis); err != nil {
            log.Fatalf("Failed to serve GPUDevice: %v", err)
        }
    }()

    // Handle OS interrupts for graceful shutdown
    c := make(chan os.Signal, 1)
    signal.Notify(c, os.Interrupt, syscall.SIGTERM)
    <-c
    log.Println("Shutting down GPUDevice server gracefully...")
    grpcServer.GracefulStop()
    log.Println("GPUDevice server stopped.")
}
