#!/bin/bash
PHUSION_USER="${PHUSION_USER-user}"

if [ $# -eq 0 ]; then
    /sbin/setuser "${PHUSION_USER}" \
        bash -l
    exit $?
elif [ -f "/etc/entrypoint.d/$1" ]; then
    # Intentionally not calling 'shift'
    /sbin/setuser "${PHUSION_USER}" \
        "/etc/entrypoint.d/$1" \
        "$@"
else
    /sbin/setuser "${PHUSION_USER}" \
        "$@"
fi
exit $?
