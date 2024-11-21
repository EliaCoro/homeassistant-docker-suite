#!/bin/bash

# Include the file with the process_templates function
source "./scripts/functions/process_templates.bash"

source "scripts/functions/check_env.bash"

if [[ -z "$DATA_FOLDER" ]]; then
    echo "[ERROR] DATA_FOLDER is not set in the .env file."
    exit 1
fi

# Call the process_templates function with parameters
process_templates "configuration/zigbee2mqtt" "$DATA_FOLDER/zigbee2mqtt"
