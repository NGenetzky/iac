# [Choice] Debian version: buster, stretch
ARG VARIANT="buster"

# [Choice] Debian version: standard, security, vnc
ARG DEBASE_VARIANT="standard"

# You can pick any Debian/Ubuntu-based image.
# ARG FROM_IMAGE="buildpack-deps:${VARIANT}-curl"
# ARG FROM_IMAGE="jgoerzen/debian-base-standard:${VARIANT}"
ARG FROM_IMAGE="jgoerzen/debian-base-${DEBASE_VARIANT}:${VARIANT}"

FROM ${FROM_IMAGE}

COPY library-scripts/*.sh /tmp/library-scripts/

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && apt-get install -y libssl-dev libffi-dev python3-dev python3-pip \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Ansible
# RUN pip3 install ansible[azure]

# # [Option] Install Azure CLI
# ARG INSTALL_AZURE_CLI="true"
# # [Option] Install Docker CLI
# ARG INSTALL_DOCKER="true"
# # [Option] Install Node.js
# ARG INSTALL_NODE="true"
# ARG NODE_VERSION="lts/*"
# ENV NVM_DIR=/usr/local/share/nvm
# ENV NVM_SYMLINK_CURRENT=true \
#     PATH=${NVM_DIR}/current/bin:${PATH}
# RUN if [ "${INSTALL_AZURE_CLI}" = "true" ]; then bash /tmp/library-scripts/azcli-debian.sh; fi \
#     && if [ "${INSTALL_AZURE_CLI}" = "true" ]; then bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}"; fi \
#     && if [ "${INSTALL_DOCKER}" = "true" ]; then \
#         bash /tmp/library-scripts/docker-debian.sh "true" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}"; \
#     else \
#         echo '#!/bin/bash\n"$@"' > /usr/local/share/docker-init.sh && chmod +x /usr/local/share/docker-init.sh; \
#     fi \
#     && rm -rf /var/lib/apt/lists/*

# ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
ENTRYPOINT ["/usr/local/bin/boot-debian-base"]
CMD [ "sleep", "infinity" ]

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
