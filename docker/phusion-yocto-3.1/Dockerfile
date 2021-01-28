
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

ENTRYPOINT ["/sbin/my_init", "--quiet", "--skip-startup-files"]
WORKDIR /work/
ENV LANG en_US.UTF-8
