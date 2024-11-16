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

# Process each template file
print_status "Processing templates from directory: $TEMPLATE_DIR"


# Process each template file
for TEMPLATE_FILE in "$TEMPLATE_DIR"/*; do
    TEMPLATE_NAME=$(basename "$TEMPLATE_FILE")
    OUTPUT_FILE="$OUTPUT_DIR/$TEMPLATE_NAME"

    print_status "Processing $TEMPLATE_FILE -> $OUTPUT_FILE..."

    # Render the template
    envsubst < "$TEMPLATE_FILE" > "$OUTPUT_FILE"

    # Check if the rendering was successful
    if [[ $? -eq 0 ]]; then
        print_status "Template rendered successfully: $OUTPUT_FILE"
    else
        print_status "Error: Failed to render template $TEMPLATE_FILE."
        exit 1
    fi
done
