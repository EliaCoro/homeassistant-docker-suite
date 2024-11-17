#!/bin/bash

# Function to print status messages
print_status() {
    echo "[STATUS] $1"
}

# Path to the .env file
ENV_FILE=".env"

# Check if .env file exists
if [[ ! -f $ENV_FILE ]]; then
    print_status "Error: .env file not found."
    exit 1
fi

# Export variables from the .env file into the current shell environment
set -o allexport
source "$ENV_FILE"
set +o allexport

# Path to the template directory
TEMPLATE_DIR="configuration/home-assistant"

# Path to the output directory
OUTPUT_DIR="$DATA_FOLDER/home-assistant"

# Create the output directory if it doesn't exist
if [[ ! -d $OUTPUT_DIR ]]; then
    mkdir -p "$OUTPUT_DIR"
    print_status "Created output directory: $OUTPUT_DIR"
fi

# Process templates recursively
print_status "Processing templates from directory: $TEMPLATE_DIR"

# Find all files in the template directory and process them
find "$TEMPLATE_DIR" -type f | while read -r TEMPLATE_FILE; do
    # Calculate the relative path of the file
    RELATIVE_PATH="${TEMPLATE_FILE#$TEMPLATE_DIR/}"
    OUTPUT_FILE="$OUTPUT_DIR/$RELATIVE_PATH"

    # Ensure the output directory for the file exists
    OUTPUT_SUBDIR=$(dirname "$OUTPUT_FILE")
    if [[ ! -d $OUTPUT_SUBDIR ]]; then
        mkdir -p "$OUTPUT_SUBDIR"
        print_status "Created output subdirectory: $OUTPUT_SUBDIR"
    fi

    # Process the template
    print_status "Processing $TEMPLATE_FILE -> $OUTPUT_FILE..."
    envsubst < "$TEMPLATE_FILE" > "$OUTPUT_FILE"

    # Check if the rendering was successful
    if [[ $? -eq 0 ]]; then
        print_status "Template rendered successfully: $OUTPUT_FILE"
    else
        print_status "Error: Failed to render template $TEMPLATE_FILE."
        exit 1
    fi
done

print_status "All templates processed successfully."
