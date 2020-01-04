FROM node:10
LABEL maintainer "Nathan Genetzky <nathan@genetzky.us>"

USER "node"
WORKDIR "/home/node"
RUN echo "prefix =  ${HOME}/.local" > "${HOME}/.npmrc" \
    && npm install -g gogs-cli \
    && sed -i \
        -e 's@#!/usr/bin/node@#!/usr/bin/env node@' \
        "${HOME}/.local/lib/node_modules/gogs-cli/bin/cli.js"

ENV PATH "${HOME}/.local/bin:${PATH}"
VOLUME /home/node/.config/gogs-cli/
ENTRYPOINT ["/home/node/.local/lib/node_modules/gogs-cli/bin/cli.js"]
