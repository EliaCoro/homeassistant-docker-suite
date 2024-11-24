#!/bin/bash

# Function to print status messages
print_status() {
    echo "[STATUS] $1"
}

source "scripts/functions/check_env.bash"


if [[ -z "$DATA_FOLDER" ]]; then
    echo "$DATA_FOLDER"
    echo "[ERROR] DATA_FOLDER is not set in the .env file."
    exit 1
fi

# Check the system architecture
arch=$(uname -m)

# Stop and remove all running containers
print_status "Stopping and removing containers..."
docker compose down

# Check if the command was successful
if [ $? -ne 0 ]; then
    print_status "Error: Docker compose failed. Please run 'installation.bash' first."
    exit 1
fi

service="--profile base "

if [[ "$ZIGBEE" == "Y" ]]; then
    service+="--profile zigbee "
fi

if [[ "$BACKUPS" == "Y" ]]; then
    service+="--profile backups "
fi

# If the architecture is arm64 (ARM 64-bit), use the --platform flag
if [[ "$arch" == "aarch64" ]]; then
    print_status "Architecture is ARM64. Starting containers with --platform linux/arm64/v8."
    docker compose --platform linux/arm64/v8 $service up -d
else
    print_status "Starting containers"
    docker compose $service up -d
fi

# sleep 5
# docker exec -it nodered bash
