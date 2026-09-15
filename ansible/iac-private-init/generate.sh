#!/usr/bin/env bash

#
# Generate a new private "iac-private" repository skeleton.
#

set -euo pipefail

PROGNAME="$(basename "$0")"
cd "$(dirname "$0")"

usage() {
  cat <<EOF
usage: $0 --dest DIR [-- extra ansible-playbook args]
EOF
}


help() {
  usage
  cat <<EOF
Options:
  --dest DIR            Directory to create the iac-private repo in
                        (must not already exist, unless --force is given)
  --force               Reuse an existing --dest directory
EOF
}

DEST=""
EXTRA_VARS=()

while test $# -gt 0; do
  case $1 in
    --dest)
      DEST=$2
      shift 2
      ;;
    --force)
      EXTRA_VARS+=("-e" "iac_private_scaffold_force=true")
      shift 1
      ;;
    --help)
      help
      exit 0
      ;;
    --)
      shift 1
      break
      ;;
    *)
      echo "${PROGNAME}: unknown option $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "${DEST}" ]]; then
  echo "${PROGNAME}: --dest is required" >&2
  usage >&2
  exit 1
fi

set -x
exec ansible-playbook -e "dest=${DEST}" "${EXTRA_VARS[@]}" generate.yml "$@"
