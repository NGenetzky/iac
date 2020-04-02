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

# Configuration for default non-root user.
ARG USER_NAME='user'
ARG USER_UID='1000'
ARG USER_GID="$USER_UID"
ARG USER_SHELL='/usr/bin/zsh'
# Create non-root user and give them sudo with nopasswd.
RUN printf "### Building image for user %s (%s:%s) ###" \
        "${USER_NAME}" \
        "${USER_UID}" \
        "${USER_GID}" \
    #
    # Create a non-root user.
    && groupadd --gid "$USER_GID" \
        "$USER_NAME" \
    && useradd --create-home --shell "${USER_SHELL}" \
        --uid "${USER_UID}" --gid "${USER_GID}" \
        "${USER_NAME}" \
    #
    # Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/$USER_NAME" \
    && chmod 0440 "/etc/sudoers.d/$USER_NAME" \
    #
    # Special steps for vscode remote-container support
    && install -d --mode 0777 --owner "${USER_UID}" --group "${USER_GID}" \
        "/workspace/" \
        \
        '/root/.vscode-server/' \
        '/root/.vscode-server/bin/' \
        '/root/.vscode-server/extensions' \
        \
        "/home/$USER_NAME/.vscode-server" \
        "/home/$USER_NAME/.vscode-server/bin" \
        "/home/$USER_NAME/.vscode-server/extensions"

USER "${USER_NAME}"
WORKDIR "/home/${USER_NAME}/"
