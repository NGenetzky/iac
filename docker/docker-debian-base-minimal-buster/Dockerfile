# https://github.com/jgoerzen/docker-debian-base-minimal
# FROM "jgoerzen/debian-base-minimal"
FROM "jgoerzen/debian-base-standard:sid"

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
ARG USER_MAIN_ID=1000
ARG USER_MAIN_NAME='user'
ARG USER_MAIN_SHELL='/bin/bash'

RUN rm -r '/etc/skel/' \
    #
    # Add user after we configure /etc/skel
    && groupadd --gid "${USER_MAIN_ID}" "${USER_MAIN_NAME}" \
    && useradd --shell "${USER_MAIN_SHELL}" --uid "${USER_MAIN_ID}" --gid "${USER_MAIN_ID}" -m "${USER_MAIN_NAME}" \
    #
    # [Optional] Add sudo support
    && echo "${USER_MAIN_NAME} ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER_MAIN_NAME}" \
    && chmod 0440 "/etc/sudoers.d/${USER_MAIN_NAME}" \
    && ssh-import-id gh:ngenetzky

WORKDIR "/home/${USER_MAIN_NAME}/"

CMD ["/usr/local/bin/boot-debian-base"]
