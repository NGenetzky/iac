#!/bin/sh

multipass_launch(){
    multipass \
        launch \
        --cpus '2' --mem '2G' \
        --cloud-init "-" \
        "$@" \
        'release:20.04' \
        < "${D_SCRIPT}/user-data.yaml"
}

D_SCRIPT="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
multipass_launch "$@"
