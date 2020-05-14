#!/bin/bash
APT_PKGS=""
# These are from 'debops'
# https://docs.debops.org/en/master/introduction/install.html
#
# You can install them using your distribution packages on Debian or Ubuntu by
# running the command:
APT_PKGS="${APT_PKGS} \
python3-future python3-ldap python3-netaddr \
python3-dnspython python3-passlib python3-openssl \
"
# Building cryptography on Linux
APT_PKGS="${APT_PKGS} \
build-essential libssl-dev libffi-dev python3-dev \
"

sudo apt install ${APT_PKGS}
