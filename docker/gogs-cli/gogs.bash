#!/bin/bash
set -eux
_CONFIG_DIR="${HOME}/.config/gogs-cli/"
mkdir -p "${_CONFIG_DIR}"
docker run -it \
    -u "$(id -u ${USER}):$(id -g ${USER})" \
    -v "${_CONFIG_DIR}:/home/node/.config/gogs-cli/" \
    gogs-cli \
    "$@"
