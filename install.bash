#!/bin/bash

# List of .bash files to execute
SCRIPTS=(
  "install_docker.bash"
  "generate_env.bash"
  "generate_image.bash"
  "configure_home_assistant.bash"
  "configure_mosquitto.bash"
)

prefix="scripts"

# Iterate through the list of scripts
for script in "${SCRIPTS[@]}"; do
  # Check if the file exists and is executable
  file="$prefix/$script"
  if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' does not exist."
    exit 1
  fi

  if [[ ! -x "$file" ]]; then
    echo "Error: File '$file' is not executable. Fixing permissions..."
    chmod +x "$file" || { echo "Failed to make '$file' executable."; exit 1; }
  fi

  # Execute the script (source it to preserve interactive behavior)
  echo "Running '$file'..."
  source "$file"

  # Check if the script executed successfully
  if [[ $? -ne 0 ]]; then
    echo "Error: Script '$file' failed to execute."
    exit 1
  fi
done

echo "All scripts executed successfully."
