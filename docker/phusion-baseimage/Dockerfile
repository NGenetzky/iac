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

# Using "ARG" influences the behavior of apt only while building container.
# No Debian that's a bad Debian! We don't have an interactive prompt don't fail
ARG DEBIAN_FRONTEND=noninteractive

# We don't use phusion's "install_clean" because we want portability.
RUN apt-get --quiet --yes update \
    # We first install these packages, to avoid skipping package configuration
    && apt-get -y install --no-install-recommends \
        apt-utils \
        dialog \
    # Then we can proceed with our minimal packages
    && apt-get -y install --no-install-recommends \
    # # Basic tools
        sudo \
        tmux \
        vim \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

################################################################################
# phusion magic
#
# phusion specific magic starts here. Must use FROM 'phusion/*'.
#
# - init scripts (/etc/my_init.d/)
# - init process (/sbin/my_init)
#
####
RUN install -d \
    '/etc/entrypoint.d/' \
    '/etc/my_init.d/'

# Use baseimage-docker's init to execute our custom entrypoint.
COPY entrypoint.sh /sbin/entrypoint
COPY entrypoint.d/ /etc/entrypoint.d/
ENTRYPOINT ["/sbin/my_init", "--", "/sbin/entrypoint"]

# phusion specific magic ends here.
################################################################################

################################################################################
# WIP Layers
####

# mainstream apt packages that I use frequently
RUN apt-get --quiet --yes update \
    && apt-get -y install --no-install-recommends \
        #
        # Core development tools
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
        # Python development tools
        python3-dbg \
        python3-dbus \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        \
        # Python2 development tools
        python-dbg \
        python-dbus \
        python-dev \
        python-gobject \
        python-pip \
        python-setuptools \
        python-wheel \
        # Other development tools
        clang-format \
        tcl \
    #
    # Additional tools installed with pip
    && pip install \
        pre-commit \
        tox \
        virtualenvwrapper \
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

ARG USER_REF='origin/ngenetzky/novo'
USER "${USER_NAME}"
ARG HOME="/home/${USER_NAME}"
RUN rm \
        "${HOME}/.bash_logout" \
        "${HOME}/.bashrc" \
        "${HOME}/.profile" \
    && install -m 700 -d \
        "${HOME}/.ssh" \
    && yadm clone 'https://github.com/NGenetzky/home.git' \
    && yadm checkout 'origin/ngenetzky/novo' -b "live/$(hostname)" \
    && "${HOME}/.yadm/bootstrap" \
    # TODO: This should be in bootstrap
    && zsh -c 'source ~/.zshrc'

USER root

# Archive the home directory in case user want's to mount over it.
RUN tar -vcap \
    -f "/usr/share/home-${USER_NAME}.tar.xz" \
    -C "/home/${USER_NAME}" \
    ./

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
ARG DOCKER_REPO='ngenetzky/phusion-base'
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
