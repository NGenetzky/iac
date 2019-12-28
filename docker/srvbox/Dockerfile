FROM ubuntu:18.04 as base-0

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
        apt-utils \
        dialog \
    # Basic tools
    && apt-get install -y \
        build-essential \
        ca-certificates \
        curl \
        git \
        gnupg-agent \
        lsb-release \
        make \
        man \
        openssh-server \
        procps \
        software-properties-common \
        sudo \
        tmux \
        unzip \
        vim \
    #
    # Install Ansible
    && apt-get install -y \
        libffi-dev \
        libssl-dev \
        python-dev \
        python-pip \
    && pip install ansible \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ARG TINI_VERSION='v0.18.0'
RUN  wget "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" \
        -O '/tini' \
    && chmod +x '/tini'
ENTRYPOINT ["/tini", "--"]
FROM base-0 as base-1

# Create 'main' user
ARG USER_MAIN_ID=1000
ARG USER_MAIN_NAME='user'
RUN groupadd --gid "${USER_MAIN_ID}" "${USER_MAIN_NAME}" \
    && useradd --uid "${USER_MAIN_ID}" --gid "${USER_MAIN_ID}" -m "${USER_MAIN_NAME}" \
    #
    # [Optional] Add sudo support
    && echo "${USER_MAIN_NAME} ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER_MAIN_NAME}" \
    && chmod 0440 "/etc/sudoers.d/${USER_MAIN_NAME}"

# Set up for pairing with wemux.
# upstream: git://github.com/zolrath/wemux.git
RUN git clone 'git://github.com/haraldkl/wemux.git' '/usr/local/src/wemux' \
    && cd '/usr/local/src/wemux' \
    && git checkout -b 'build' '0b9a16f82f07b923faf0013af4c23ebe1cc2a78b' \
    && install -d '/usr/local/man/man1' '/usr/local/share/doc/wemux' \
    && make install \ 
    && echo "host_list=(root ${USER_MAIN_NAME})" >> /usr/local/etc/wemux.conf

ARG URL_KEYS="https://github.com/NGenetzky.keys"
RUN \
    # sshd config
    mkdir /var/run/sshd \
    && echo "AllowAgentForwarding yes" >> /etc/ssh/sshd_config \
    ## ssh authorized key management
    && install -m '0700' \
        -o "${USER_MAIN_ID}" -g "${USER_MAIN_ID}" \
        -d "/home/${USER_MAIN_NAME}/.ssh/" \
    && wget "${URL_KEYS}" \
        -O "/home/${USER_MAIN_NAME}/.ssh/authorized_keys" \
    && chmod "0644" \
        "/home/${USER_MAIN_NAME}/.ssh/authorized_keys" \
    && chown "${USER_MAIN_ID}:${USER_MAIN_ID}" \
        "/home/${USER_MAIN_NAME}/.ssh/authorized_keys"

FROM base-1 as base-2

# Configure apt and install packages
RUN apt-get update  \
    && apt-get install -y --no-install-recommends \
        git-annex \
        python3 \
        python3-pip \
        python3-setuptools \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install \
    datalad \
    jupyterlab \
    organize-tool

ARG USER_MAIN_NAME='user'
RUN usermod --shell '/bin/bash' "${USER_MAIN_NAME}"

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
