#!/bin/bash
# https://wiki.ubuntu.com/FoundationsTeam/AutomatedServerInstalls/QuickStart

cd 'build/'
kvm -no-reboot -m 1024 \
    -drive file=image.img,format=raw,cache=none,if=virtio
