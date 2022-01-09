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
