#!/bin/sh
# Example from debian-base-minimal:
#
# docker run -td --stop-signal=SIGRTMIN+3 \
#   --tmpfs /run:size=100M --tmpfs /run/lock:size=100M \
#   -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
#   --name=name 'jgoerzen/debian-base-minimal' "$@"

D_SCRIPT="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
cd "${D_SCRIPT}"

NAME="$(basename "${D_SCRIPT}")"

# NOTE: Choosing not to use same uid and username.
# --build-arg "USER_ID=$(id -u)"
# --build-arg "USERNAME=$(id -un)"
docker build --rm -t "${NAME}" \
    ./

docker stop "${NAME}" || true
docker rm "${NAME}" || true

docker run -td --rm \
   --stop-signal=SIGRTMIN+3 \
   --tmpfs /run:size=100M \
   --tmpfs /run/lock:size=100M \
   -v '/sys/fs/cgroup:/sys/fs/cgroup:ro' \
   -e DEBBASE_SSH='enabled' \
   -p '127.0.0.1:1022:22' \
   --name="${NAME}" \
   "${NAME}"
