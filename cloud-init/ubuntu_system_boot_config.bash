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
