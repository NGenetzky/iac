#!/bin/sh
# docker run -td --stop-signal=SIGRTMIN+3 \
#   --tmpfs /run:size=100M --tmpfs /run/lock:size=100M \
#   -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
#   --name=name 'jgoerzen/debian-base-minimal' "$@"

docker pull jgoerzen/debian-base-standard:sid

docker run -td \
   --stop-signal=SIGRTMIN+3 \
   --tmpfs /run:size=100M \
   --tmpfs /run/lock:size=100M \
   -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
   --name=debian-sid \
   jgoerzen/debian-base-standard:sid

# docker start debian-sid
# docker exec -it debian-sid bash
