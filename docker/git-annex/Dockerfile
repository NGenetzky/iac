FROM python:3

################################################################################
# docker-pygit2
# github.com/mikechernev/docker-pygit2/
#
ENV LIBGIT_VERSION 0.27.0

# Cmake is a dependency for building libgit2
RUN apt-get update && apt-get install -y cmake \
# Downloading and building libgit2
    && wget https://github.com/libgit2/libgit2/archive/v${LIBGIT_VERSION}.tar.gz \
    && tar xzf v${LIBGIT_VERSION}.tar.gz \
    && cd libgit2-${LIBGIT_VERSION} \
    && cmake . \ 
    && make \
    && make install \
# The python wrapper for libgit2
    && pip install pygit2 \
# Required for updating the libs
    && ldconfig
#
################################################################################

################################################################################
# docker-git-annex
#

ARG DEBIAN_FRONTEND=noninteractive
RUN  \
  # Add neuro.debian.net repository
  wget \
    -O /etc/apt/sources.list.d/neurodebian.sources.list \
    http://neuro.debian.net/lists/xenial.us-nh.full \
  && apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9 \
  # Install git-annex
  && apt-get update &&  apt-get install -y \
    git-annex-standalone \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

#
################################################################################

################################################################################
# git-annex-adapter
#

RUN \
    # fetch
    git clone git://github.com/alpernebbi/git-annex-adapter.git '/usr/local/src/git-annex-adapter' \
    && cd '/usr/local/src/git-annex-adapter' \
    && git checkout -b 'build' 'v0.2.1' \
    # compile + install
    && python setup.py install \
    # clean
    && rm -rf '/usr/local/src/git-annex-adapter'

#
################################################################################

# Create non-root user
ARG USER_ID=1000
ARG USER_NAME='user'
RUN groupadd --gid "${USER_ID}" "${USER_NAME}" \
    && useradd --uid "${USER_ID}" --gid "${USER_ID}" -m "${USER_NAME}"

USER "${USER_NAME}"
WORKDIR "/home/${USER_NAME}"
ENTRYPOINT ["git-annex"]
