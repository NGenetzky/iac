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
FROM phusion/baseimage:0.11

# Add apt repository from neuro debian
# "http://neuro.debian.net/lists/bionic.us-tn.full"
# Install ppa key for 'neurodebian' so that we can install the
# latest 'git-annex' (Ubuntu 18.04 only has 6.20180227-1).
# http://neuro.debian.net/install_pkg.html?p=git-annex-standalone
# WARNING: Building this layer can fail sporadically.
RUN curl \
        -o "/etc/apt/sources.list.d/neurodebian.sources.list" \
            "http://neuro.debian.net/lists/bionic.us-tn.full" \
    && apt-key adv --recv-keys \
        --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9

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

# Configuration for default non-root user.
ARG USER_NAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Create non-root user and give them sudo with nopasswd.
RUN printf "### Building image for user %s (%s:%s) ###" \
        "${USER_NAME}" \
        "${USER_UID}" \
        "${USER_GID}" \
    #
    # Create a non-root user.
    && groupadd \
        --gid "$USER_GID" \
        "$USER_NAME" \
    && useradd \
        -s /bin/bash \
        --uid "$USER_UID" \
        --gid "$USER_GID" \
        -m "$USER_NAME" \
    #
    # Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/$USER_NAME" \
    && chmod 0440 "/etc/sudoers.d/$USER_NAME" \
    #
    # Special steps for vscode remote-container support
    && install -d \
        "/workspace/"

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
    #
    # Install git-annex and datalad
    && apt-get -y install \
        git-annex-standalone \
        datalad \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

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
