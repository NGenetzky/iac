##################################################################################
# phusion-ngenetzky Dockerfile
#
# References
# - https://github.com/NGenetzky/iac/
# - https://medium.com/@tonistiigi/advanced-multi-stage-build-patterns-6f741b852fae
#
#
# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
#
# https://github.com/phusion/baseimage-docker/releases
# ___________________________________________________________
# | Ubuntu LTS | Phusion | Notes from Phusion       |
# |------------|---------|--------------------------|
# |   18.04    | 1.0.0   | released on Jun 04, 2020 |
# |   18.04    |  0.11   | released on Aug 16, 2018 |
# |   16.04    | 0.9.22  | released on May 17, 2017 |
#
####

FROM phusion/baseimage:bionic-1.0.0 as phusion-ngenetzky-bionic-1.0.0

# Using "ARG" influences the behavior of apt only while building container.
# No Debian that's a bad Debian! We don't have an interactive prompt don't fail
ARG DEBIAN_FRONTEND=noninteractive

# ngnetzky-ubuntu-apt-layer0-base
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
        user.name 'User Phusion' \
    && git config --system \
        user.email 'user@phusion-ngenetzky' \
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

# ngnetzky-ubuntu-apt-layer1-main
# mainstream apt packages that I use frequently
RUN apt-get --quiet --yes update \
    && apt-get -y install --no-install-recommends \
        ####
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
        ####
        # Python development tools
        # python3-dbus \
        python3-dbg \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-venv \
        python3-wheel \
        ####
        # Python2 development tools
        # python-dbg \
        # python-dbus \
        # python-dev \
        # python-gobject \
        # python-pip \
        # python-setuptools \
        # python-wheel \
        #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

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

# 2.6: https://www.yoctoproject.org/docs/2.6/mega-manual/mega-manual.html#required-packages-for-the-build-host
# ARG YOCTO_APT_REQ="gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping"
# https://github.com/crops/yocto-dockerfiles/blob/344ac54cba52bbca3a47fb89b5db1469a54e8d8f/dockerfiles/ubuntu/ubuntu-18.04/ubuntu-18.04-base/Dockerfile#L1
ARG YOCTO_APT_REQ="gawk wget git-core subversion diffstat unzip sysstat texinfo gcc-multilib g++-multilib build-essential chrpath socat python python3 xz-utils locales cpio screen tmux sudo iputils-ping iproute2 fluxbox tightvncserver"

# setuptools required for to install kas with python3.
# locales required to set LC_ALL for using bitbake.
# 'file' is required "HOSTTOOL" for poky.
# 'iproute2': 'ip' is required "HOSTTOOL" for poky.
# 'iptables': 'iptables' is required to 'runqemu'
ARG YOCTO_APT_REQ_APPEND="python3-setuptools locales file iproute2 iptables"
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
    # apt packages
    apt-get update --yes && \
    apt-get install --no-install-recommends --yes \
        ${YOCTO_APT_REQ} \
        ${YOCTO_APT_REQ_APPEND} \
    && \
    # Clean up
    apt-get autoremove -y && \
    apt-get clean --yes && \
    rm -rf /var/lib/apt/lists/* && \
    \
    # python3 packages
    python3 -m pip install --no-cache-dir --disable-pip-version-check \
        ${YOCTO_PYTHON_REQ} \
        ${EXTRA_PYTHON_REQ}

# Misc System level config
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
RUN \
    # VNC
    cp -af /etc/skel/ /etc/vncskel/ && \
    echo "export DISPLAY=1" >>/etc/vncskel/.bashrc && \
    mkdir  /etc/vncskel/.vnc && \
    echo "" | vncpasswd -f > /etc/vncskel/.vnc/passwd && \
    chmod 0600 /etc/vncskel/.vnc/passwd && \
    \
    # Locales
    /usr/sbin/locale-gen en_US.UTF-8 && \
    \
    echo 'dash dash/sh boolean false' | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

COPY ./rootfs/ /

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
