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
    port = flag.Int("port", 60050, "Port number for GPUCoordinator service")
)

func main() {
    flag.Parse()

    initialDevices := []*pb.DeviceMetadata{
        {
            DeviceId:   &pb.DeviceId{Value: 1},
            MinMemAddr: &pb.MemAddr{Value: 0x1000},
            MaxMemAddr: &pb.MemAddr{Value: 0x100000}, // would have a larger range for real scenarios
            Rank:       &pb.Rank{Value: 0},
        },
        {
            DeviceId:   &pb.DeviceId{Value: 2},
            MinMemAddr: &pb.MemAddr{Value: 0x2000},
            MaxMemAddr: &pb.MemAddr{Value: 0x100000},
            Rank:       &pb.Rank{Value: 1},
        },
        {
            DeviceId:   &pb.DeviceId{Value: 3},
            MinMemAddr: &pb.MemAddr{Value: 0x3000},
            MaxMemAddr: &pb.MemAddr{Value: 0x100000},
            Rank:       &pb.Rank{Value: 2},
        },
    }

    coordinator := dsml.NewGPUCoordinatorService(initialDevices)

    lis, err := net.Listen("tcp", fmt.Sprintf(":%d", *port))
    if err != nil {
        log.Fatalf("Failed to listen on port %d: %v", *port, err)
    }

    grpcServer := grpc.NewServer()
    pb.RegisterGPUCoordinatorServer(grpcServer, coordinator)

    go func() {
        log.Printf("GPUCoordinator listening on port %d", *port)
        if err := grpcServer.Serve(lis); err != nil {
            log.Fatalf("Failed to serve GPUCoordinator: %v", err)
        }
    }()

    // Handle OS interrupts for graceful shutdown
    c := make(chan os.Signal, 1)
    signal.Notify(c, os.Interrupt, syscall.SIGTERM)
    <-c
    log.Println("Shutting down GPUCoordinator server gracefully...")
    grpcServer.GracefulStop()
    log.Println("GPUCoordinator server stopped.")
}
