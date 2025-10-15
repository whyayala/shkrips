#!/bin/sh

# Verified on macos. Will write certificate to a file.
echo | openssl s_client -showcerts -verify 5 -connect artifactory.forge-dev.rise8.us:443 -servername artifactory.forge-dev.rise8.us < /dev/null | openssl x509 > cert.pem
