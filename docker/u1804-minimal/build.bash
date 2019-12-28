#!/bin/bash

D_SCRIPT="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
NAME="$(basename "${D_SCRIPT}")"

docker build --rm -t "${NAME}" \
    --build-arg "USER_MAIN_ID=$(id -u)" \
    --build-arg "USER_MAIN_NAME=$(id -un)" \
    ./

