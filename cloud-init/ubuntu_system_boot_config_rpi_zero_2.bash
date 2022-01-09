#!/bin/bash
echoerr(){ echo "$*" >&2 ; }
die(){ echo "$*" >&2 ; exit 1 ; }

BOOTDIR="${1?Required argument}"

D_SCRIPT="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
CONFIGDIR="${D_SCRIPT}/ubuntu-20.04-preinstalled-server-arm64/"

cd "${CONFIGDIR}" || die "failed to cd to CONFIGDIR"
cp -t "${BOOTDIR}" \
    README \
    cmdline.txt \
    config.txt \
    meta-data \
    network-config \
    syscfg.txt \
    user-data \
    usercfg.txt

# references:
# - https://askubuntu.com/a/1385048
# - https://waldorf.waveform.org.uk/2021/the-pi-zero-2.html
# - https://waldorf.waveform.org.uk/2021/you-boot-no-u-boot-first.html

# reuse dtb for rpi 3b for rpi zero 2
cp "${BOOTDIR}/bcm2710-rpi-3-b.dtb" "${BOOTDIR}/bcm2710-rpi-zero-2.dtb"
# skip u-boot
cp "${CONFIGDIR}/config-rpi-zero-2.txt" "${BOOTDIR}/config.txt"
