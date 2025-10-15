#!/bin/sh

# Verified on macos. Will write certificate for the passed in hostname to a file.
echo | openssl s_client -showcerts -verify 5 -connect $1:443 -servername $1 < /dev/null | openssl x509 > cert.pem

# Verified on macos. Will copy cert to podman and update it's trusts. May need to login to registry again or restart host.
podman machine ssh podman-machine-default "mkdir -p /etc/containers/certs.d/$1" 
podman machine cp ./cert.pem podman-machine-default:/etc/containers/certs.d/$1/ca.crt
podman machine ssh podman-machine-default "update-ca-trust" 
