#!/bin/bash

# Function to print status messages
print_status() {
    echo "[STATUS] $1"
}

# Check the system architecture
arch=$(uname -m)

# Stop and remove all running containers
print_status "Stopping and removing containers..."
docker-compose down

# Check if the command was successful
if [ $? -ne 0 ]; then
    print_status "Error: Docker compose failed. Please run 'installation.bash' first."
    exit 1
fi

# If the architecture is arm64 (ARM 64-bit), use the --platform flag
if [[ "$arch" == "aarch64" ]]; then
    print_status "Architecture is ARM64. Starting containers with --platform linux/arm64/v8."
    docker-compose up -d --platform linux/arm64/v8
else
    print_status "Starting containers"
    docker-compose up -d
fi

# sleep 5
# docker exec -it nodered bash
