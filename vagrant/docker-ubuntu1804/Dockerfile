ARG FROM_IMAGE="tknerr/baseimage-ubuntu:18.04"

# phusion/baseimage:bionic-1.0.0-amd64
# Digest:sha256:0481bb9b387564c43bd5d44cacf44efb492fd1e7bd1716e849262036b69c030c
ARG FROM_IMAGE="phusion/baseimage:bionic-1.0.0-amd64@sha256:0481bb9b387564c43bd5d44cacf44efb492fd1e7bd1716e849262036b69c030c"

FROM "${FROM_IMAGE}"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-utils \
    && \
    apt-get install -y --no-install-recommends \
        openssh-server sudo wget python-simplejson \
    && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configuration for default non-root user.
# ARG USER_NAME='user'
ARG USER_NAME='vagrant'
ARG USER_UID='1000'
ARG USER_GID="$USER_UID"
ARG USER_SHELL='/bin/bash'
ARG USER_PW='vagrant'
# Create non-root user and give them sudo with nopasswd.
RUN \
    # Create a non-root user.
    groupadd --gid "$USER_GID" "$USER_NAME" && \
    useradd --create-home --shell "${USER_SHELL}" \
        --uid "${USER_UID}" --gid "${USER_GID}" "${USER_NAME}" && \
    echo "${USER_NAME}:${USER_PW}" | chpasswd \
    #
    # Add sudo support for the non-root user
    && echo "$USER_NAME ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USER_NAME" \
    && chmod 0440 "/etc/sudoers.d/$USER_NAME"

ARG URL_KEYS='https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
# insecure vagrant public key
# ARG SSH_AUTHORIZED_KEYS="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ=="
RUN \
    echo "AllowAgentForwarding yes" >> '/etc/ssh/sshd_config' && \
    ## ssh authorized key management
    install -m '0700' -o "${USER_NAME}" -g "${USER_NAME}" -d "/home/${USER_NAME}/.ssh/" && \
    wget --quiet --no-check-certificate "${URL_KEYS}" -O "/home/${USER_NAME}/.ssh/authorized_keys" && \
    chmod 0600 "/home/${USER_NAME}/.ssh/authorized_keys" && \
    chown -R "${USER_NAME}" "/home/${USER_NAME}" && \
    \
    mkdir -p /var/run/sshd && \
    date > /etc/vagrant_box_build_time && \
    #####
    # WARNING: Phusion magic here
    rm -f '/etc/service/sshd/down' && \
    # Regenerate SSH host keys. baseimage-docker does not contain any, so you
    # have to do that yourself. You may also comment out this instruction; the
    # init system will auto-generate one during boot.
    '/etc/my_init.d/00_regen_ssh_host_keys.sh'
EXPOSE 22
