#!/bin/sh

# Function to show usage
usage() {
    echo "Usage: $0 -p CERTS_PATH"
    exit 1
}

# Initialize variables
CERTS_PATH=""

# Parse command-line options using getopts
while getopts "p:h" opt; do
    case ${opt} in
    p)
        CERTS_PATH=${OPTARG}
        ;;
    h)
        usage
        ;;
    \?)
        usage
        ;;
    esac
done

# Ensure that the CERTS_PATH argument is provided
if [ -z "$CERTS_PATH" ]; then
    usage
fi

# Create the certs directory and its parent directories if they don't exist
mkdir -p "$CERTS_PATH"

# Navigate to the certs directory
cd "$CERTS_PATH" || {
    echo "Failed to change directory to $CERTS_PATH"
    exit 1
}

# Generate the CA private key with a password prompt (-des3)
openssl genrsa -des3 -out myCA.key 2048

# Generate the self-signed certificate
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem
