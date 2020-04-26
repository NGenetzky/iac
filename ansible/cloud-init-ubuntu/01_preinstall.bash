#!/bin/bash

# Bash Strict Mode # For scripts that already depend on Bash.
set -eu -o pipefail
IFS=$'\n\t'

if [ ! -f 'build/cdrom/casper/vmlinuz' ]; then
    echo 'Please mount cdrom'
    exit 1
fi

if [ ! -f 'build/image.img' ]; then
    truncate -s 10G 'build/image.img'
fi

cd "build/cloud_init"
python3 -m http.server 3003

