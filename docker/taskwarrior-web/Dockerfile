
# Usage:
# docker build -t taskwarrior-web ./
# docker run -it -p 5678:5678 -v "$(pwd)/data:/root/" taskwarrior-web
FROM alpine:3.7

ARG BUILDDIR='/usr/local/src/taskwarrior-web'
WORKDIR "${BUILDDIR}"

RUN apk add --no-cache task ruby python \
    && apk add --no-cache --virtual .build-dependencies \
        ruby-dev \
        make \
        g++ \
        git \
    # fetch
    && git clone 'git://github.com/theunraveler/taskwarrior-web.git' "${BUILDDIR}" \
    && cd "${BUILDDIR}" \
    && git checkout -b 'build' 'a79cfe2b42791b62364118e58b21b892fff6ded8' \
    # build and install
    && install -m 644 "${BUILDDIR}/docker/.taskrc" '/root/.taskrc' \
    && GEM="$(gem build taskwarrior-web.gemspec | awk '/File: .*/{ print $2 }')" \
    && gem install "${GEM}" --no-document \
    # Clean up
    && apk del --no-cache .build-dependencies

EXPOSE 5678
VOLUME '/root/'
ENTRYPOINT ["task-web"]
CMD ["-F", "-L"]
