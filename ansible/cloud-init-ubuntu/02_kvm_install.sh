#!/bin/sh
# https://wiki.ubuntu.com/FoundationsTeam/AutomatedServerInstalls/QuickStart

cd 'build/'
kvm -no-reboot -m 1024 \
    -drive file=image.img,format=raw,cache=none,if=virtio \
    -cdrom cdrom.iso \
    -kernel cdrom/casper/vmlinuz \
    -initrd cdrom/casper/initrd \
    -append 'autoinstall ds=nocloud-net;s=http://_gateway:3003/'
