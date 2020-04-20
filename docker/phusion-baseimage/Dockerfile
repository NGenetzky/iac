# phusion-ngenetzky Dockerfile

# References
# - https://github.com/NGenetzky/iac/
# - https://medium.com/@tonistiigi/advanced-multi-stage-build-patterns-6f741b852fae

##################################################################################
##################################################################################
# FROM phusion/baseimage:0.11 as phusion-ngenetzky-0.11-r0
#
# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
#
# https://github.com/phusion/baseimage-docker/releases
# ___________________________________________________________
# | Ubuntu LTS | Phusion | Notes from Phusion       |
# |------------|---------|--------------------------|
# |   18.04    |  0.11   | released on Aug 16, 2018 |
# |   16.04    | 0.9.22  | released on May 17, 2017 |
#
#########
#########

FROM phusion/baseimage:0.11 as phusion-ngenetzky-0.11-r0
COPY .docker/phusion/rootfs/ /

# Using "ARG" influences the behavior of apt only while building container.
# No Debian that's a bad Debian! We don't have an interactive prompt don't fail
ARG DEBIAN_FRONTEND=noninteractive

# ngnetzky-ubuntu-apt-layer0
# We don't use phusion's "install_clean" because we want portability.
RUN apt-get --quiet --yes update \
    # We first install these packages
    # 'apt-utils dialog' to avoid skipping package configuration
    # 'git' so that we can configure etckeeper
    # 'sudo' so that we can add users to it below.
    && apt-get -y install --no-install-recommends \
        apt-utils \
        dialog \
        git \
        sudo \
    && git config --system \
        user.name 'Nathan Genetzky' \
    && git config --system \
        user.email 'nathan@genetzky.us' \
    && ( \
        cd etc/ \
        && git init \
        && git remote add origin \
            'https://github.com/NGenetzky/etckeeper-base-etc' \
        && git pull 'origin' 'master' \
    ) \
    && apt-get -y install --no-install-recommends \
        # etckeeper should be installed after configuring things above
        etckeeper \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ngnetzky-ubuntu-etc-skel
RUN cd '/etc/skel/' \
    # Configure vim with sensible defaults.
    && curl -o '/etc/skel/.vimrc' \
        'https://raw.githubusercontent.com/tpope/vim-sensible/2d9f34c09f548ed4df213389caa2882bfe56db58/plugin/sensible.vim' \
    # Configure bash with sensible defaults.
    && curl -o '/usr/local/share/bash-sensible.bash' \
        "https://raw.githubusercontent.com/mrzool/bash-sensible/5a2269a6a12e2a1b10629bb223f2f3c27ac07050/sensible.bash" \
    && ( \
        printf 'f=%s && [[ -f $f ]] && source $f' \
            "'/usr/local/share/bash-sensible.bash'" \
    ) >> '/etc/skel/.bashrc'

# Configuration for default non-root user.
ARG USER_NAME='user'
ARG USER_UID='1000'
ARG USER_GID="$USER_UID"
ARG USER_SHELL='/bin/bash'
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
    && echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/$USER_NAME" \
    && chmod 0440 "/etc/sudoers.d/$USER_NAME" \
    #
    # Setup directories for home user
    && install -d --mode 0755 --owner "${USER_UID}" --group "${USER_GID}" \
        # 'bin' for XDG Base Directory Specification
        # https://www.freedesktop.org/software/systemd/man/file-hierarchy.html#Home%20Directory
        "/home/$USER_NAME/bin" \
        "/home/$USER_NAME/.local/bin" \
        # vscode remote-container support
        "/home/$USER_NAME/workspace/" \
        "/home/$USER_NAME/.vscode-server" \
        "/home/$USER_NAME/.vscode-server/bin" \
        "/home/$USER_NAME/.vscode-server/extensions" \
    && install -d --mode 0775 --owner "${USER_UID}" --group "${USER_GID}" \
        # vscode remote-container support
        "/workspace/" \
        "/workspaces/"

################################################################################
# WIP Layers
####

# mainstream apt packages that I use frequently
####RUN apt-get --quiet --yes update \
####    && apt-get -y install --no-install-recommends \
####        #
####        # Core development tools
####        bash \
####        build-essential \
####        ca-certificates \
####        curl \
####        git \
####        lsb-release \
####        sudo \
####        tmux \
####        vim \
####        yadm \
####        zsh \
####        #
####        # Python development tools
####        python3-dbg \
####        python3-dbus \
####        python3-dev \
####        python3-pip \
####        python3-setuptools \
####        python3-wheel \
####        \
####        # Python2 development tools
####        python-dbg \
####        python-dbus \
####        python-dev \
####        python-gobject \
####        python-pip \
####        python-setuptools \
####        python-wheel \
####        # Other development tools
####        clang-format \
####        tcl \
####    #
####    # Additional tools installed with pip
####    && pip install \
####        pre-commit \
####        tox \
####        virtualenvwrapper \
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


################################################################################
# phusion magic
#
# phusion specific magic starts here. Must use FROM 'phusion/*'.
#
# - init scripts (/etc/my_init.d/)
# - init process (/sbin/my_init)
# - entrypoint (/sbin/entrypoint)
#
# NOTE: '/sbin/entrypoint' was added by ngenetzky not phusion.
####

USER root

# Use baseimage-docker's init to execute our custom entrypoint.
ENTRYPOINT ["/sbin/my_init", "--", "/sbin/entrypoint"]

####
# phusion magic
################################################################################

################################################################################
# docker metadata
####

# docker-hub environment-variables
# https://docs.docker.com/docker-hub/builds/advanced/#environment-variables-for-building-and-testing
#
# SOURCE_BRANCH: the name of the branch or the tag that is currently being tested.
# SOURCE_COMMIT: the SHA1 hash of the commit being tested.
# COMMIT_MSG: the message from the commit being tested and built.
# DOCKER_REPO: the name of the Docker repository being built.
# DOCKERFILE_PATH: the dockerfile currently being built.
# DOCKER_TAG: the Docker repository tag being built.
# IMAGE_NAME: the name and tag of the Docker repository being built. (This variable is a combination of DOCKER_REPO:DOCKER_TAG.)
ARG SOURCE_BRANCH='unknown-branch'
ARG SOURCE_COMMIT='unknown-commit'
ARG DOCKER_REPO='ngenetzky/phusion-ngenetzky'
ARG DOCKERFILE_PATH='Dockerfile'
ARG DOCKER_TAG='latest'
ARG IMAGE_NAME="${DOCKER_REPO}:${DOCKER_TAG}"

# Programatic Metadata
# TODO: BUILD_DATE
ARG BUILD_DATE='unknown-date'

# Hardcoded Metadata
ARG META_VCS_URL='https://github.com/ngenetzky/iac/'
ARG META_SUMMARY='Image built ontop of phusion-baseimage'
ARG META_MAINTAINER='Nathan Genetzky <n@genetzky.us>'

# Yocto Metadata
# https://wiki.yoctoproject.org/wiki/Releases

# Build-time metadata as defined at http://label-schema.org
LABEL \
    maintainer="${META_MAINTAINER}" \
    summary="${META_SUMMARY}" \
    description="${META_SUMMARY}" \
    authors="${META_MAINTAINER}" \
    url="$META_VCS_URL" \
    \
    org.label-schema.build-date="$BUILD_DATE" \
    org.label-schema.name="$IMAGE_NAME" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vcs-ref="$SOURCE_COMMIT" \
    org.label-schema.vcs-url="$META_VCS_URL" \
    org.label-schema.version="$SOURCE_COMMIT"
