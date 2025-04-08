# syntax=docker/dockerfile:1

FROM golang:1.23.0 AS build-stage

WORKDIR /app

# Copy go.mod and go.sum first to cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the entire project directory
COPY . .

# Change to the videorecservice directory with the server.go file
WORKDIR /app/video_rec_service/server

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /docker-gs-ping

FROM alpine:latest AS build-release-stage 

WORKDIR /

COPY --from=build-stage /docker-gs-ping /docker-gs-ping

EXPOSE 8080 

# Set the entry point for the container
# CMD 
ENTRYPOINT ["/docker-gs-ping"]