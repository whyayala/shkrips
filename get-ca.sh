#!/bin/sh

# Verified on macos
openssl s_client -showcerts -verify 5 -connect artifactory.forge-dev.rise8.us:443 < /dev/null
