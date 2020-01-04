FROM node:10
LABEL maintainer "Nathan Genetzky <nathan@genetzky.us>"

USER "node"
WORKDIR "/home/node"
RUN NPM_CONFIG_PREFIX="${HOME}/.local" \
    npm install -g gogs-cli \
    && echo 'PATH=${HOME}/.local/bin:${PATH}' > "${HOME}/.profile" \
    && sed -i \
        -e 's@#!/usr/bin/node@#!/usr/bin/env node@' \
        "${HOME}/.local/lib/node_modules/gogs-cli/bin/cli.js"

VOLUME /home/node/.config/gogs-cli/
ENTRYPOINT ["/home/node/.local/lib/node_modules/gogs-cli/bin/cli.js"]
