#!/bin/bash
# https://github.com/vagrant-libvirt/vagrant-libvirt/blob/master/README.md#installation

set -eu

apt-get build-dep \
    ruby-libvirt \
    vagrant

apt-get install \
    dnsmasq-base \
    ebtables \
    libvirt-clients \
    libvirt-daemon-system \
    libvirt-dev \
    libxml2-dev \
    libxslt-dev \
    qemu \
    ruby-dev \
    zlib1g-dev

# vagrant plugin install vagrant-libvirt