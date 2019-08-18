#!/bin/bash

git_annex(){
    local args="$*"
    docker run -it \
        -u "${UID}" \
        git-annex \
        "${args}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Bash Strict Mode
    set -eu -o pipefail

    # set -x
    git_annex "$@"
fi

