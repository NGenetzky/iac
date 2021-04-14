# phusion/baseimage:bionic-1.0.0-amd64
# Digest:sha256:0481bb9b387564c43bd5d44cacf44efb492fd1e7bd1716e849262036b69c030c
ARG FROM_IMAGE="phusion/baseimage:bionic-1.0.0-amd64@sha256:0481bb9b387564c43bd5d44cacf44efb492fd1e7bd1716e849262036b69c030c"

FROM "${FROM_IMAGE}"

ARG REQ_DIR="/usr/src/req/"
ARG REQ_APT_APPEND="\
openssh-server \
python3 \
"

# COPY src/req/ "${REQ_DIR}"
RUN apt-get -q update && export DEBIAN_FRONTEND=noninteractive && \
    mkdir -p "${REQ_DIR}" && \
    echo "$REQ_APT_APPEND" | sed -E -e 's/[[:blank:]]+/\n/g' >> "${REQ_DIR}/apt.txt" && \
    awk '! /^ *(#|$)/' "${REQ_DIR}/apt.txt" | \
        xargs -r -- apt-get --no-install-recommends -yq install && \
    # Clean up
    apt-get autoremove -y && apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /root/.cache/*

# Configuration for default non-root user.
ARG USERNAME='vagrant'
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Extra user config:
ARG USER_SHELL='/bin/bash'

# Create non-root user and give them sudo with nopasswd.
RUN printf "### Building image for user %s (%s:%s) ###" \
        "${USERNAME}" "${USER_UID}" "${USER_GID}" && \
    # Create a non-root user.
    groupadd --gid "$USER_GID" "$USERNAME" && \
    useradd --create-home --shell "${USER_SHELL}" \
        --uid "${USER_UID}" --gid "${USER_GID}" "${USERNAME}" && \
    # Add sudo support for the non-root user
    mkdir -p '/etc/sudoers.d/' && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/$USERNAME" && \
    chmod 0440 "/etc/sudoers.d/$USERNAME" && \
    #
    # Setup directories for home user
    install -d --mode 0755 --owner "${USER_UID}" --group "${USER_GID}" \
        # 'bin' for XDG Base Directory Specification
        # https://www.freedesktop.org/software/systemd/man/file-hierarchy.html#Home%20Directory
        "/home/$USERNAME/.local/" \
        "/home/$USERNAME/.local/bin" \
        "/home/$USERNAME/.local/share" \
        "/home/$USERNAME/.local/src" \
        "/home/$USERNAME/bin" \
        && \
    install -d --mode 0755 --owner "${USER_UID}" --group "${USER_GID}" \
        "/work/" "/srv/" "/opt/"

# insecure public ssh key from vagrant
ARG SSH_AUTHKEYS_URL="https://raw.githubusercontent.com/hashicorp/vagrant/22795b161bf67a4c0ebbe32c9ce8777cb888c4a7/keys/vagrant.pub"
ARG SSH_USER_PASS="*"
RUN \
    echo "AllowAgentForwarding yes" >> '/etc/ssh/sshd_config' \
    && usermod -p "${SSH_USER_PASS}" "${USERNAME}" \
    ## ssh authorized key management
    && install -m '0700' \
        -o "${USER_UID}" -g "${USER_GID}" \
        -d "/home/${USERNAME}/.ssh/" \
    # && wget "${SSH_AUTHKEYS_URL}" -O "/tmp/authorized_keys" \
    && curl "${SSH_AUTHKEYS_URL}" > "/tmp/authorized_keys" \
    && install -T -m '0600' \
        -o "${USER_UID}" -g "${USER_GID}" \
        "/tmp/authorized_keys" \
        "/home/${USERNAME}/.ssh/authorized_keys" \
    && rm "/tmp/authorized_keys" \
    #####
    # WARNING: Phusion magic here
    && rm -f '/etc/service/sshd/down' \
    # Regenerate SSH host keys. baseimage-docker does not contain any, so you
    # have to do that yourself. You may also comment out this instruction; the
    # init system will auto-generate one during boot.
    && '/etc/my_init.d/00_regen_ssh_host_keys.sh'
EXPOSE 22
