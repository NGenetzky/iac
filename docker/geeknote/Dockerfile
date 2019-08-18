FROM ubuntu:18.04

# This is the proper way to disable questions from 'apt' during build.
ARG DEBIAN_FRONTEND=noninteractive

RUN \
    # Configure apt and install packages
    apt-get update \
    && apt-get -y install --no-install-recommends \
        apt-utils \
        dialog \
    #
    # Dependencies
    && apt-get install -y \
        git \
        libsqlite3-dev \
        ca-certificates \
        vim-nox \
        python-pip \
        python-sqlalchemy \
        python-html2text \
        python-thrift \
        python-oauth \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Original: git://github.com/VitaliyRodnenko/geeknote.git
RUN \
    # fetch
    git clone 'git://github.com/jeffkowalski/geeknote.git' '/usr/local/src/geeknote' \
    && cd '/usr/local/src/geeknote' \
    && git checkout 'e43267fa87290167cc1a6cc2ffbdc2a34b374017' \
    # compile + install
    && pip install --requirement 'requirements.txt' \
    && python setup.py install \
    # clean
    && rm -rf '/usr/local/src/geeknote'

ENTRYPOINT ["geeknote"]

# Create non-root user
ARG USER_ID=1000
ARG USER_NAME='user'
RUN groupadd --gid "${USER_ID}" "${USER_NAME}" \
    && useradd --uid "${USER_ID}" --gid "${USER_ID}" -m "${USER_NAME}"

USER "${USER_NAME}"
WORKDIR "/home/${USER_NAME}"
