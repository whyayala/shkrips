#!/bin/sh

HOSTNAME=$1
CERT_OUTPUT_WITH_PATH=${2:-"cert.crt"}

# Verified on macos. Will write certificate for the passed in hostname to a file.
echo | openssl s_client -showcerts -servername "$HOSTNAME" -verify 5 -connect "$HOSTNAME:443" 2>/dev/null | openssl x509 --multi > "$CERT_OUTPUT_WITH_PATH"
