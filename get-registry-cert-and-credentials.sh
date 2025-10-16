#!/bin/sh

# Verified on macos. Will write certificate for the passed in hostname to a file.
echo | openssl s_client -showcerts -verify 5 -connect $1:443 -servername $1 < /dev/null | openssl x509 > cert.pem

# Podman by default does not run in rootful mode, so we will enable it temporarily.
podman machine stop
podman machine set --rootful
podman machine start

# Verified on macos. Will copy cert to podman and update it's trusts. May need to login to registry again or restart host.
podman machine ssh podman-machine-default "mkdir -p /etc/containers/certs.d/$1" 
podman machine cp ./cert.pem podman-machine-default:/etc/containers/certs.d/$1/ca.crt
podman machine ssh podman-machine-default "update-ca-trust" 

# Disable rootful mode
podman machine stop
podman machine set --rootful=false
podman machine start

# Because podman is cucked by docker, the compose extension is actually just an alias to docker compose.
# The super fun and awesome thing about this that's not well documented at all is that podman login stores
# credentials in a different location than where docker compose looks for them. The simplest solution is to
# just create a symlink from where podman login stores the cred to where docker compose will be looking for
# them.
ln -s ~/.config/containers/auth.json ~/.docker/config.json
