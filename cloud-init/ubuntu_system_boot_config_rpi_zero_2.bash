#!/bin/bash
echoerr(){ echo "$*" >&2 ; }
die(){ echo "$*" >&2 ; exit 1 ; }

D_SCRIPT="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
_DEFAULT_CONFIGDIR="${D_SCRIPT}/ubuntu-20.04-preinstalled-server-arm64/"

BOOTDIR="${1?Required argument}"
CONFIGDIR="${2-"${_DEFAULT_CONFIGDIR}"}"

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

# skip u-boot
cp "config-rpi-zero-2.txt" "${BOOTDIR}/config.txt"
# reuse dtb for rpi 3b for rpi zero 2
cp "${BOOTDIR}/bcm2710-rpi-3-b.dtb" "${BOOTDIR}/bcm2710-rpi-zero-2.dtb"
