#!/bin/bash
set -eu

groups_want=(
    adm
    cdrom
    dialout
    docker
    kvm
    libvirt
    libvirt-qemu
    lpadmin
    plugdev
    sambashare
    sudo
    syslog
)

################################################################################

# https://stackoverflow.com/a/2990533 # by James Roth
# echoerr() { printf "%s\n" "$*" >&2; }
log_info(){ printf "INFO: %s\n" "$*" >&2; }

# https://stackoverflow.com/a/17841619 # by Nicholas Sushkin, Lynn
function join_by { local IFS="$1"; shift; echo "$*"; }

################################################################################

this_user="$(id -un)"
groups_user_has="$(id)"
groups_system_has="$(getent group)"

groups_to_add=()
for g in "${groups_want[@]}"; do
    if [[ "$groups_user_has" == *"$g"* ]]; then
        log_info "user has $g"
        continue
    fi
    if [[ "$groups_system_has" != *"$g"* ]]; then
        log_info "system is missing $g"
        continue
    fi

    log_info "groups_to_add+=( $g )"
    groups_to_add+=( "$g" )
done

if [[ "${#groups_to_add[@]}" == 0 ]]; then
    log_info "user has all desired groups"
    exit 0
fi
groups_to_add_str="$(join_by , "${groups_to_add[@]}")"

log_info "armed: sudo usermod -a -G "${groups_to_add_str}" "${this_user}""
sudo usermod -a -G "${groups_to_add_str}" "${this_user}"
