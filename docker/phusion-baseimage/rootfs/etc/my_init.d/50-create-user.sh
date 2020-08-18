#!/bin/bash
# Bash Debugging
# set -x

# Bash Strict mode
set -e -o pipefail
# set -u # TODO: Want to enable, but needs some work

# These variable names were choosen to match 'dockcross'
if [[ -n $BUILDER_UID ]] && [[ -n $BUILDER_GID ]]; then
    BUILDER_UID="${BUILDER_UID:-1000}"
    BUILDER_GID="${BUILDER_GID:-${BUILDER_UID}}"
    BUILDER_USER="${BUILDER_USER:-user}"
    BUILDER_GROUP="${BUILDER_GROUP:-${BUILDER_USER}}"
    BUILDER_SHELL="${BUILDER_SHELL:-/bin/bash}"

    # TODO: Handle case where it exists, but needs modification.
    if ! id -u "$BUILDER_USER" &>/dev/null ; then
        groupadd -o \
            -g $BUILDER_GID $BUILDER_GROUP \
            2> /dev/null

        useradd -o -m \
            ${BUILDER_SHELL:+--shell $BUILDER_SHELL} \
            -g $BUILDER_GID -u $BUILDER_UID $BUILDER_USER \
            2> /dev/null
    fi

    HOME_OF_NEW_USER="/home/${BUILDER_USER}"
    if [ ! -f "${HOME_OF_NEW_USER}/.bash_history" ] ; then
        # export HOME=/home/${BUILDER_USER} # Don't set HOME if you don't need it.
        shopt -s dotglob
        cp -r -t "$HOME_OF_NEW_USER/" /root/*
        chown -R "$BUILDER_UID:$BUILDER_GID" "$HOME_OF_NEW_USER"
    fi

    # TODO: Allow to be disabled.
    # Create non-root user and give them sudo with nopasswd.
    echo "$BUILDER_USER ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/$BUILDER_USER" && \
    chmod 0440 "/etc/sudoers.d/$BUILDER_USER"

    #  disable password-based access to an account while allowing SSH access
    #  (with some other authentication method, typically a key pair)
    usermod -p '*' "$BUILDER_USER"
else
    printf "\nWARNING: No user created\n"
fi
