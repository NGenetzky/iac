FROM node:10
LABEL maintainer "Nathan Genetzky <nathan@genetzky.us>"

USER "node"
WORKDIR "/home/node"
RUN NPM_CONFIG_PREFIX="${HOME}/.local" \
    npm install -g joplin \
    && echo 'PATH=${HOME}/.local/bin:${PATH}' > "${HOME}/.profile"

ENTRYPOINT ["/home/node/.local/bin/joplin"]
