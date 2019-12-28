#!/bin/bash

D_SCRIPT="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
NAME="$(basename "${D_SCRIPT}")"

docker run -d --rm  \
    -p '10122:22' \
    -p '10180:8888' \
    -v '/:/mnt/:ro' \
    -v "/data/ngenetzky/workspaces/notebook:/home/ngenetzky/workspace/" \
    "${NAME}"
