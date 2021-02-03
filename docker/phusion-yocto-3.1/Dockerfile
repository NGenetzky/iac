FROM phusion/baseimage:bionic-1.0.0

# 3.1: https://www.yoctoproject.org/docs/3.1/mega-manual/mega-manual.html#required-packages-for-the-build-host
ARG YOCTO_APT_REQ_3_1="gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm"
ARG YOCTO_APT_REQ="${YOCTO_APT_REQ_3_1}"

# setuptools required for to install kas with python3.
# locales required to set LC_ALL for using bitbake.
# 'file' is required "HOSTTOOL" for poky.
# 'iproute2': 'ip' is required "HOSTTOOL" for poky.
# 'iptables': 'iptables' is required to 'runqemu'
ARG YOCTO_APT_REQ_APPEND="python3-setuptools locales file iproute2 iptables"

RUN apt-get --quiet --yes update && \
    # We first install these packages
    # 'apt-utils dialog' to avoid skipping package configuration
    apt-get -y install --no-install-recommends \
        apt-utils \
        dialog \
    && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ${YOCTO_APT_REQ} \
        ${YOCTO_APT_REQ_APPEND} \
    && \
    # Clean up
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Misc System level config
RUN \
    set -x && \
    # Locales
    /usr/sbin/locale-gen en_US.UTF-8 && \
    \
    echo 'dash dash/sh boolean false' | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# python3 installs
ARG YOCTO_PYTHON_REQ="\
kas==2.2 \
PyYAML>=3.0 \
distro>=1.0.0 \
jsonschema>=2.5.0 \
"
RUN \
  set -x && \
  python3 -m pip install --no-cache-dir --disable-pip-version-check \
    ${YOCTO_PYTHON_REQ}

ARG UBUNTU_MIRROR='archive.ubuntu.com'
#install dependences:
RUN set -x \
  sed -i.bak s/archive.ubuntu.com/${UBUNTU_MIRROR}/g /etc/apt/sources.list && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
    build-essential \
    sudo \
    tofrodos \
    iproute2 \
    gawk \
    net-tools \
    expect \
    libncurses5-dev \
    tftpd \
    update-inetd \
    libssl-dev \
    flex \
    bison \
    libselinux1 \
    gnupg \
    wget \
    socat \
    gcc-multilib \
    libsdl1.2-dev \
    libglib2.0-dev \
    lib32z1-dev \
    zlib1g:i386 \
    libgtk2.0-0 \
    screen \
    pax \
    diffstat \
    xvfb \
    xterm \
    texinfo \
    gzip \
    unzip \
    cpio \
    chrpath \
    autoconf \
    lsb-release \
    libtool \
    libtool-bin \
    locales \
    kmod \
    git \
    rsync \
    bc \
    u-boot-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

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
    && groupadd --gid "${USER_GID}" \
        "${USER_NAME}" \
    && useradd --create-home --shell "${USER_SHELL}" \
        --uid "${USER_UID}" --gid "${USER_GID}" \
        "${USER_NAME}" \
    #
    # Add sudo support for the non-root user
    # && echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/$USER_NAME" \
    # && chmod 0440 "/etc/sudoers.d/$USER_NAME" \
    #
    # Setup directories for home user
    && install -d --mode 0755 --owner "${USER_UID}" --group "${USER_GID}" \
        # 'bin' for XDG Base Directory Specification
        # https://www.freedesktop.org/software/systemd/man/file-hierarchy.html#Home%20Directory
        "/home/${USER_NAME}/bin" \
        "/home/${USER_NAME}/.local/" \
        "/home/${USER_NAME}/.local/bin" \
        "/home/${USER_NAME}/.local/share"

USER root
ENTRYPOINT ["/sbin/my_init", "--quiet", "--skip-startup-files"]
WORKDIR /work/
ENV LANG en_US.UTF-8
