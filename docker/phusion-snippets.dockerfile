

ARG YOCTO_PYTHON_REQ="\
kas==2.1.1 \
PyYAML>=3.0 \
distro>=1.0.0 \
jsonschema>=2.5.0 \
"
ARG EXTRA_PYTHON_REQ="\
virtualenvwrapper \
tmuxp \
"
RUN \
  set -x && \
  python3 -m pip install --no-cache-dir --disable-pip-version-check \
    ${YOCTO_PYTHON_REQ} \
    ${EXTRA_PYTHON_REQ}


# # Configuration for default non-root user.
# ARG USER_NAME='user'
# ARG USER_UID='1000'
# ARG USER_GID="$USER_UID"
# ARG USER_SHELL='/bin/bash'
# # Create non-root user and give them sudo with nopasswd.
# RUN printf "### Building image for user %s (%s:%s) ###" \
#         "${USER_NAME}" \
#         "${USER_UID}" \
#         "${USER_GID}" \
#     #
#     # Create a non-root user.
#     && groupadd --gid "$USER_GID" \
#         "$USER_NAME" \
#     && useradd --create-home --shell "${USER_SHELL}" \
#         --uid "${USER_UID}" --gid "${USER_GID}" \
#         "${USER_NAME}" \
#     #
#     # Add sudo support for the non-root user
#     && echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/$USER_NAME" \
#     && chmod 0440 "/etc/sudoers.d/$USER_NAME" \
#     #
#     # Setup directories for home user
#     && install -d --mode 0755 --owner "${USER_UID}" --group "${USER_GID}" \
#         # 'bin' for XDG Base Directory Specification
#         # https://www.freedesktop.org/software/systemd/man/file-hierarchy.html#Home%20Directory
#         "/home/$USER_NAME/bin" \
#         "/home/$USER_NAME/.local/" \
#         "/home/$USER_NAME/.local/bin" \
#         "/home/$USER_NAME/.local/share" \
#         # vscode remote-container support
#         "/home/$USER_NAME/workspace/" \
#         "/home/$USER_NAME/.vscode-server" \
#         "/home/$USER_NAME/.vscode-server/bin" \
#         "/home/$USER_NAME/.vscode-server/extensions" \
#     && install -d --mode 0775 --owner "${USER_UID}" --group "${USER_GID}" \
#         # vscode remote-container support
#         "/workspace/" \
#         "/workspaces/"

# # ngnetzky-user-ssh-authorized_keys-from-github
# ARG URL_KEYS="https://github.com/NGenetzky.keys"
# RUN \
#     echo "AllowAgentForwarding yes" >> '/etc/ssh/sshd_config' \
#     ## ssh authorized key management
#     && install -m '0700' \
#         -o "${USER_UID}" -g "${USER_GID}" \
#         -d "/home/${USER_NAME}/.ssh/" \
#     && wget "${URL_KEYS}" \
#         -O "/home/${USER_NAME}/.ssh/github-ngenetzky.keys" \
#     && install -T -m '0600' \
#         -o "${USER_UID}" -g "${USER_GID}" \
#         "/home/${USER_NAME}/.ssh/github-ngenetzky.keys" \
#         "/home/${USER_NAME}/.ssh/authorized_keys" \
#     #####
#     # WARNING: Phusion magic here
#     && rm -f '/etc/service/sshd/down' \
#     # Regenerate SSH host keys. baseimage-docker does not contain any, so you
#     # have to do that yourself. You may also comment out this instruction; the
#     # init system will auto-generate one during boot.
#     && '/etc/my_init.d/00_regen_ssh_host_keys.sh'
# EXPOSE 22

################################################################################
# WIP Layers
####

##### ngnetzky-ubuntu-apt-layer2-special-or-wip
####RUN apt-get --quiet --yes update \
####    && apt-get -y install --no-install-recommends \
####        shellcheck \
####    ####
####    # Additional tools installed with pip
####    && pip3 install --no-cache-dir \
####        cookiecutter \
####        ipykernel \
####        jupyter \
####        jupyter-repo2docker \
####        jupytext \
####        nbconvert \
####        papermill \
####        ptpython \
####        pylint \
####        tmuxp \
####    #
####    # Clean up
####    && apt-get autoremove -y \
####    && apt-get clean -y \
####    && rm -rf /var/lib/apt/lists/*

##### ngnetzky-ubuntu-docker
####RUN apt-get --quiet --yes update \
####    && apt-get -y install --no-install-recommends \
####        docker-compose \
####        docker.io \
####        git \
####        iproute2 \
####        procps \
####    ####
####    # Additional tools installed with pip
####    && pip3 install --no-cache-dir \
####        docker \
####    ####
####    # Enable the main user to use docker
####    && usermod -a -G "docker" "${USER_NAME}" \
####    #
####    # Clean up
####    && apt-get autoremove -y \
####    && apt-get clean -y \
####    && rm -rf /var/lib/apt/lists/*

####ARG USER_REF='origin/ngenetzky/novo'
####USER "${USER_NAME}"
####ARG HOME="/home/${USER_NAME}"
####RUN rm \
####        "${HOME}/.bash_logout" \
####        "${HOME}/.bashrc" \
####        "${HOME}/.profile" \
####    && install -m 700 -d \
####        "${HOME}/.ssh" \
####    && yadm clone 'https://github.com/NGenetzky/home.git' \
####    && yadm checkout 'origin/ngenetzky/novo' -b "live/$(hostname)" \
####    && "${HOME}/.yadm/bootstrap" \
####    # TODO: This should be in bootstrap
####    && zsh -c 'source ~/.zshrc'

# Archive the home directory in case user want's to mount over it.
####RUN tar -vcap \
####    -f "/usr/share/home-${USER_NAME}.tar.xz" \
####    -C "/home/${USER_NAME}" \
####    ./

####
# WIP Layers
################################################################################
