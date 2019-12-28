FROM devbox
ARG USER_MAIN_NAME='ngenetzky'

# Install and use zsh
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
    # Install
        zsh \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    # Change shell
    && usermod "${USER_MAIN_NAME}" --shell '/bin/zsh'

USER "${USER_MAIN_NAME}"
WORKDIR "/home/${USER_MAIN_NAME}/"
RUN install -m 700 -d \
    "${HOME}/.vscode-server" \
    "${HOME}/.ssh"
