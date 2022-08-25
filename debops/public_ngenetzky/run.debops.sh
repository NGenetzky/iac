#!/bin/bash
set -eu -o pipefail

export ANSIBLE_LOG_PATH=".ansible_log.log"

set -x

debops "$@"

################################################################################

# Only run netbase
#-t TAGS, --tags TAGS  only run plays and tasks tagged with these values
#debops --tags 'role::netbase'

