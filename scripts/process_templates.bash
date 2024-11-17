#!/bin/bash

# Function to print status messages
print_status() {
    echo "[STATUS] $1"
}

# Function to process templates recursively
process_templates() {
    # Parameters
    local TEMPLATE_DIR=$1
    local OUTPUT_DIR=$2

    # Check if template directory exists
    if [[ ! -d $TEMPLATE_DIR ]]; then
        print_status "Error: Template directory $TEMPLATE_DIR not found."
        exit 1
    fi

    # Create the output directory if it doesn't exist
    if [[ ! -d $OUTPUT_DIR ]]; then
        mkdir -p "$OUTPUT_DIR"
        sudo chmod 777 -R "$OUTPUT_DIR"
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
}
