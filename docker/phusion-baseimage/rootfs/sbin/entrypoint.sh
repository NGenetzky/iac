#!/bin/sh
set -eu

BUILDER_USER="${BUILDER_USER-user}"

if [ $# -eq 0 ]; then
    /sbin/setuser "${BUILDER_USER}" \
        bash -l
elif [ -f "/etc/entrypoint.d/$1" ]; then
    # Intentionally not calling 'shift'
    /sbin/setuser "${BUILDER_USER}" \
        "/etc/entrypoint.d/$1" \
        "$@"
else
    /sbin/setuser "${BUILDER_USER}" \
        "$@"
fi
exit $?
