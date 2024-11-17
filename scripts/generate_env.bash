#!/bin/bash

# Check if the .env.example file exists
if [[ ! -f scripts/.env.example ]]; then
  echo "Error: The .env.example file does not exist."
  exit 1
fi

# Check if the .env file already exists and ask the user if they want to overwrite it
if [[ -f .env ]]; then
  echo -n ".env file already exists. Do you want to overwrite it? (Y/n): "
  read overwrite
  if [[ "$overwrite" != "Y" && "$overwrite" != "y" && "$overwrite" != "" ]]; then
    echo "Operation cancelled. The .env file was not overwritten."
    return
  fi
fi

# Create or overwrite the .env file
> .env
echo "Generating .env file from .env.example..."

# Read the .env.example file line by line
while IFS= read -r line; do
  # Skip empty lines and comments
  if [[ -z "$line" || "$line" =~ ^# ]]; then
    echo "$line" >> .env
    continue
  fi

  # Extract the key and default value
  key=$(echo "$line" | cut -d '=' -f 1)
  default_value=$(echo "$line" | cut -d '=' -f 2-)

  # Prompt the user to enter a value
  if [[ -n "$default_value" ]]; then
    echo -n "Enter value for $key [$default_value]: "
  else
    echo -n "Enter value for $key: "
  fi

  # Read input until a non-empty value is provided
  while true; do
    read input_value <&1

    # If the value is empty and no default is provided, ask again
    if [[ -z "$input_value" && -z "$default_value" ]]; then
      echo -n "The value for $key cannot be empty. Please try again: "
      continue
    fi

    # Exit the loop once a valid value is provided
    break
  done

  # If no input is given, use the default value
  if [[ -z "$input_value" ]]; then
    if [[ "$default_value" == "randomString()" ]]; then
      input_value=$(openssl rand -hex 16)
    else
      input_value="$default_value"
    fi
  fi

  # Write the key-value pair to the .env file
  echo "$key=$input_value" >> .env
done < scripts/.env.example

echo "The .env file has been successfully generated."
