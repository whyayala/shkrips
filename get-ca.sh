#!/bin/sh

# Verified on macos. Will write certificate for the passed in hostname to a file.
echo | openssl s_client -showcerts -verify 5 -connect $1:443 -servername $1 < /dev/null | openssl x509 > cert.pem
