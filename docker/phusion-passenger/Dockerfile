
# https://github.com/phusion/passenger-docker
FROM phusion/passenger-customizable:1.0.9

# Set correct environment variables.
ENV HOME /root

# Use phusion/baseimage-docker's init process.
# TODO: Should I use CMD or ENTRYPOINT?
CMD ["/sbin/my_init"]
# ENTRYPOINT ["/sbin/my_init"]

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features.
RUN /pd_build/python.sh
RUN /pd_build/nodejs.sh

# Avoid warnings by using noninteractive during build (don't use ENV)
ARG DEBIAN_FRONTEND=noninteractive

# Install ppa key for 'neurodebian' so that we can install the
# latest 'git-annex' (Ubuntu 18.04 only has 6.20180227-1).
# http://neuro.debian.net/install_pkg.html?p=git-annex-standalone
# TODO: Could make the URL of sources list be build arg.
# WARNING: Building this layer can fail sporadically.
RUN curl \
        -o "/etc/apt/sources.list.d/neurodebian.sources.list" \
            "http://neuro.debian.net/lists/bionic.us-tn.full" \
    && apt-key adv --recv-keys \
        --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9

# 1. Install basic tools.
# 2. Install docker. Ideally you should use this by mounting the host's docker
# socket ("/var/run/docker.sock") into the container.
# 3. Install git annex and datalad
RUN apt-get update \
    #
    # Configure apt and install packages
    && apt-get -y install --no-install-recommends \
        apt-utils \
        dialog \
    #
    # Basic tools plus docker
    && apt-get -y install \
        docker-compose \
        docker.io \
        git \
        iproute2 \
        procps \
        sudo \
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

RUN rm -f \
    # enable nginx
    '/etc/service/nginx/down' \
    # remove default site
    '/etc/nginx/sites-enabled/default'

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

COPY 'nginx-site-enabled/default.conf' \
    '/etc/nginx/sites-enabled/'
RUN mkdir -p '/srv/web/' \
    && ln -sT '/workspace/' '/srv/web/workspace'
