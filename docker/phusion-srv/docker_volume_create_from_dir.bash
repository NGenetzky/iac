#!/bin/bash

SCRIPTDIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"

docker_volume_create_from_dir(){
  local VOLUME SRC
  VOLUME="${1?}"
  SRC_ARG="${2?}"
  SRC="$(readlink -f ${SRC_ARG})"
  # -a is for archive, which preserves ownership, permissions etc.
  # -v is for verbose, so I can see what's happening (optional)
  # -h is for human-readable, so the transfer rate and file sizes are easier to read (optional)
  # -W is for copying whole files only, without delta-xfer algorithm which should reduce CPU load
  # --no-compress as there's no lack of bandwidth between local devices
  # --progress so I can see the progress of large files (optional)
  docker run --rm \
    -v "${SRC}:/src" \
    -v "${VOLUME}:/data" \
    "phusion/baseimage:0.9.22" \
      /usr/bin/rsync -aSvucnWh \
        --delete \
        --no-compress \
        "/src" \
        "/data"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Bash Strict Mode
    set -eu -o pipefail

    # set -x
    docker_volume_create_from_dir "$@"
fi

