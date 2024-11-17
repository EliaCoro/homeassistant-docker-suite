#!/bin/bash

# Include the file with the process_templates function
source "./scripts/process_templates.bash"

# Path to the .env file
ENV_FILE=".env"

# Check if .env file exists
if [[ ! -f $ENV_FILE ]]; then
    echo "[ERROR] .env file not found."
    exit 1
fi

# Export variables from the .env file into the current shell environment
set -o allexport
source "$ENV_FILE"
set +o allexport

if [[ -z "$DATA_FOLDER" ]]; then
    echo "[ERROR] DATA_FOLDER is not set in the .env file."
    exit 1
fi

# Call the process_templates function with parameters
process_templates "configuration/mosquitto" "$DATA_FOLDER/mosquitto"
