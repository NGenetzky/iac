#!/bin/bash

D_SCRIPT="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
NAME="$(basename "${D_SCRIPT}")"

docker run --rm  -it \
    "${NAME}"
