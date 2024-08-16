#!/bin/sh

# Function to show usage
usage() {
    echo "Usage: $0 -d DOMAIN -p PATH"
    exit 1
}

# Initialize variables
DOMAIN=""
CERTS_PATH=""

# Parse command-line options using getopts
while getopts "d:p:h" opt; do
    case ${opt} in
    d)
        DOMAIN=${OPTARG}
        ;;
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

# Ensure both domain and path are provided
if [ -z "$DOMAIN" ] || [ -z "$CERTS_PATH" ]; then
    usage
fi

# Create the certs directory and its parent directories if they don't exist
mkdir -p "$CERTS_PATH"

# Navigate to the certs directory
cd "$CERTS_PATH" || {
    echo "Failed to change directory to $CERTS_PATH"
    exit 1
}

# Check if myCA.pem and myCA.key exist
if [ ! -f "myCA.pem" ] || [ ! -f "myCA.key" ]; then
    echo "Required files myCA.pem or myCA.key do not exist in $CERTS_PATH"
    exit 1
fi

# Generate the private key
openssl genrsa -out "$DOMAIN.key" 2048

# Create the certificate signing request (CSR)
openssl req -new -key "$DOMAIN.key" -out "$DOMAIN.csr"

# Create the extensions file
cat >"$DOMAIN.ext" <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
EOF

# Generate the certificate
openssl x509 -req -in "$DOMAIN.csr" -CA ./myCA.pem -CAkey ./myCA.key -CAcreateserial \
    -out "$DOMAIN.crt" -days 825 -sha256 -extfile "$DOMAIN.ext"
