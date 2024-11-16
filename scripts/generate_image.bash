#!/bin/bash

# Function to print status messages
print_status() {
    echo "[STATUS] $1"
}

# Name of the image to be built
IMAGE_NAME="nodered-home-assistant"

# Dockerfile path (corretto)
DOCKERFILE_PATH="./dockerfiles/node-red/Dockerfile"

# Detect system architecture
arch=$(uname -m)

# Map system architecture to Docker platform
if [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
    PLATFORM="linux/arm64"
elif [[ "$arch" == "x86_64" ]]; then
    PLATFORM="linux/amd64"
else
    print_status "Error: Unsupported architecture ($arch)."
    exit 1
fi

print_status "Detected architecture: $arch. Using platform: $PLATFORM."

# Check if the image exists and remove it
print_status "Checking if the old image exists..."
if docker image inspect $IMAGE_NAME > /dev/null 2>&1; then
    print_status "Old image exists. Removing it..."
    docker rmi -f $IMAGE_NAME
else
    print_status "No old image found. Proceeding to build a new one."
fi

# Build the new Docker image
print_status "Building the new Docker image from $DOCKERFILE_PATH for platform $PLATFORM..."
docker build --platform $PLATFORM -t $IMAGE_NAME -f $DOCKERFILE_PATH .

# Check if the build was successful
if [ $? -eq 0 ]; then
    print_status "Docker image built successfully!"
else
    print_status "Error: Docker image build failed."
    exit 1
fi
