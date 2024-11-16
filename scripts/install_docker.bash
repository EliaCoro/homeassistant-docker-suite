#!/bin/bash

# Function to print status messages
print_status() {
    local message=$1
    local status=$2
    echo "[$status] $message"
}

# Check if Docker is installed
if command -v docker &> /dev/null; then
    print_status "Docker is already installed." "installed"
else
    # Download Docker installation script
    print_status "Downloading get-docker.sh..." "installing"
    curl -fsSL https://get.docker.com -o get-docker.sh

    # Run Docker installation script
    print_status "Installing Docker using get-docker.sh..." "installing"
    sudo sh get-docker.sh

    # Clean up Docker installation script
    rm get-docker.sh

    # Add current user to the Docker group
    print_status "Adding user to the Docker group..." "installing"
    sudo groupadd docker
    sudo usermod -aG docker "$USER"

    print_status "Docker has been installed." "installed"
fi

# Check if Docker Compose is installed
if command -v docker-compose &> /dev/null; then
    print_status "Docker Compose is already installed." "installed"
else
    # Install Docker Compose
    print_status "Installing Docker Compose..." "installing"

    sudo apt-get install -y python3-distutils docker-compose

    print_status "Docker Compose has been installed." "installed"
fi
