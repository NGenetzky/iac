# https://github.com/jgoerzen/docker-debian-base-minimal
# FROM "jgoerzen/debian-base-minimal"
# FROM "jgoerzen/debian-base-standard:sid"
FROM "jgoerzen/debian-base-security:sid"

RUN apt-get update \
    && apt-get -y install --no-install-recommends \
        apt-utils \
        dialog \
    # Basic tools
    && apt-get -y install --no-install-recommends \
        bash \
        build-essential \
        ca-certificates \
        curl \
        git \
        lsb-release \
        ssh-import-id \
        sudo \
        tmux \
        vim \
        yadm \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Create 'main' user
ARG USER_UID=1000
ARG USERNAME='user'
ARG USER_MAIN_SHELL='/bin/bash'

RUN rm -r '/etc/skel/' \
    #
    # Add user after we configure /etc/skel
    && groupadd --gid "${USER_UID}" "${USERNAME}" \
    && useradd --shell "${USER_MAIN_SHELL}" --uid "${USER_UID}" --gid "${USER_UID}" -m "${USERNAME}" \
    #
    # [Optional] Add sudo support
    && echo "${USERNAME} ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}"

WORKDIR "/home/${USERNAME}/"

ARG URL_KEYS="https://github.com/NGenetzky.keys"
RUN \
    # sshd config
    mkdir /var/run/sshd \
    && echo "AllowAgentForwarding yes" >> /etc/ssh/sshd_config \
    ## ssh authorized key management
    && install -m '0700' \
        -o "${USER_UID}" -g "${USER_UID}" \
        -d "/home/${USERNAME}/.ssh/" \
    && wget "${URL_KEYS}" \
        -O "/home/${USERNAME}/.ssh/authorized_keys" \
    && chmod "0644" \
        "/home/${USERNAME}/.ssh/authorized_keys" \
    && chown "${USER_UID}:${USER_UID}" \
        "/home/${USERNAME}/.ssh/authorized_keys"
EXPOSE 22

CMD ["/usr/local/bin/boot-debian-base"]
