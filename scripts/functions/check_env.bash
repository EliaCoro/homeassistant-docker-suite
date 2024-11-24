# Path to the .env file
ENV_FILE=".env"

# Check if .env file exists
if [[ ! -f $ENV_FILE ]]; then
    echo "[ERROR] .env file not found."
    exit 1
fi

# Load the .env file
source $ENV_FILE