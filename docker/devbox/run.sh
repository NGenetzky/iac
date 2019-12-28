#!/bin/bash

D_SCRIPT="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
NAME="$(basename "${D_SCRIPT}")"

docker run -d --rm  \
    -p '10022:22' \
    "${NAME}"
