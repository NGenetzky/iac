FROM node:8
LABEL maintainer "Nathan Genetzky <nathan@genetzky.us>"

# joplin
ENV PATH="${HOME}/.local/bin:${PATH}"
USER "node"
WORKDIR "/home/node"
RUN export NPM_CONFIG_PREFIX="${HOME}/.local" \
    && npm install -g \
        joplin-cli

ENTRYPOINT ["/home/node/.local/bin/joplin"]
