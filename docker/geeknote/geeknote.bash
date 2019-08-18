#!/bin/bash

geeknote(){
    local args="$*"
    docker run -it \
        -u "${UID}" \
        geeknote \
        "${args}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Bash Strict Mode
    set -eu -o pipefail

    # set -x
    geeknote "$@"
fi

