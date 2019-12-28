FROM ubuntu:18.04 as base-0

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
        apt-utils \
        dialog \
    # Basic tools
    && apt-get install -y \
        bash \
        build-essential \
        ca-certificates \
        curl \
        git \
        lsb-release \
        sudo \
        tmux \
        vim \
        yadm \
        zsh \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Create 'main' user
ARG USER_MAIN_ID=1000
ARG USER_MAIN_NAME='user'
ARG USER_MAIN_SHELL='/usr/bin/zsh'
RUN groupadd --gid "${USER_MAIN_ID}" "${USER_MAIN_NAME}" \
    && useradd --shell "${USER_MAIN_SHELL}" --uid "${USER_MAIN_ID}" --gid "${USER_MAIN_ID}" -m "${USER_MAIN_NAME}" \
    #
    # [Optional] Add sudo support
    && echo "${USER_MAIN_NAME} ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER_MAIN_NAME}" \
    && chmod 0440 "/etc/sudoers.d/${USER_MAIN_NAME}"

USER "${USER_MAIN_NAME}"
WORKDIR "/home/${USER_MAIN_NAME}/"
