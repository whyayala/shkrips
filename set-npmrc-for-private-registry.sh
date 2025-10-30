#!/bin/sh
# Usage: ./setup-npm-registry.sh <registry-url> <auth-token> [<comma-separated-list-of-directories>]
REGISTRY_URL=$1
TOKEN=$2

# Get registry hostname from URL
if [[ $REGISTRY_URL == http*://* ]]; then
    REGISTRY_HOSTNAME=$(echo "$REGISTRY_URL" | awk -F[/:] '{print $4}')
else
    echo "Please provide a valid URL starting with http:// or https:// for the registry."
    exit 1
fi

# Verified on macos. Will write certificate for the passed in hostname to a file.
echo | openssl s_client -showcerts -servername "$REGISTRY_HOSTNAME" -verify 5 -connect "$REGISTRY_HOSTNAME:443" 2>/dev/null | openssl x509 --multi > cert.crt

# Remove protocol for npmrc configuration
REGISTRY_URL_NO_PROTOCOL=${REGISTRY_URL#http://}
REGISTRY_URL_NO_PROTOCOL=${REGISTRY_URL_NO_PROTOCOL#https://}

echo "cafile=./cert.crt" > .npmrc
{ \
    echo "registry=$REGISTRY_URL";  \
    echo "//${REGISTRY_URL_NO_PROTOCOL}:_authToken=$TOKEN"; \
    echo "strict-ssl=true"; \
} >> .npmrc

# If an argument with a list of directories is passed, copy the generated files to those directories
if [ ! -z "$3" ]; then
    IFS=',' read -ra DIRS <<< "$4"
    for dir in "${DIRS[@]}"; do
        cp cert.crt "$dir/cert.crt"
        cp .npmrc "$dir/.npmrc"
        echo "Copied cert.crt and .npmrc to $dir"
    done
fi
