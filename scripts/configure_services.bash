#!/bin/bash

ask_Y_N() {
  while true; do
    read -r input
    input=$(echo "$input" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

    if [[ -z "$input" ]]; then
      input="Y"
    fi
    if [[ "$input" == "Y" || "$input" == "N" ]]; then
      echo "$input"
      return
    else
      echo "Invalid input. Please enter 'Y' for Yes or 'N' for No."
    fi
  done
}


echo "Would you use Zigbee network? (Y/n)"
zigbee=$(ask_Y_N)
echo "ZIGBEE=$zigbee" >> .env

source "scripts/functions/check_env.bash"

# echo "Would you enable automatic backups with Rclone? (Y/n)"
# echo "Documentation: https://rclone.org/docs/"
# backups=$(ask_Y_N)
# echo "BACKUPS=$backups" >> .env


# if [[ "$backups" == "Y" ]]; then
#   docker run -it --rm -v "$DATA_FOLDER/rclone/:/root/.config/rclone" rclone/rclone config
# fi