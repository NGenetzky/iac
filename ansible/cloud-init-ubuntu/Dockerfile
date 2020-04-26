FROM gliderlabs/alpine:3.4
ARG VERSION=2.7.2

RUN \
  apk-install \
    curl \
    openssh-client \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    py-setuptools \
    py-yaml \
    tar && \
  pip install --upgrade pip python-keyczar && \
  rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

RUN \
  curl -fsSL https://releases.ansible.com/ansible/ansible-${VERSION}.tar.gz -o ansible.tar.gz && \
  tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
  rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

# Configuration for default non-root user. [alpine busybox]
ARG USER_NAME='user'
ARG USER_UID='1000'
ARG USER_GID="$USER_UID"
ARG USER_SHELL='/bin/bash'
# Create non-root user and give them sudo with nopasswd.
RUN printf "### Building image for user %s (%s:%s) ###" \
        "${USER_NAME}" \
        "${USER_UID}" \
        "${USER_GID}" \
    #
    # Create a non-root user. No password (-D).
    && adduser -D -s "${USER_SHELL}" -u "${USER_UID}" "${USER_NAME}" \
    #
    # Add sudo support for the non-root user
    # && echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > "/etc/sudoers.d/$USER_NAME" \
    # && chmod 0440 "/etc/sudoers.d/$USER_NAME" \
    #
    # Setup directories for home user
    # && install -d --mode 0755 --owner "${USER_UID}" --group "${USER_GID}" \
    && install -d -m 0755 -o "${USER_UID}" -g "${USER_GID}" \
        # 'bin' for XDG Base Directory Specification
        # https://www.freedesktop.org/software/systemd/man/file-hierarchy.html#Home%20Directory
        "/home/$USER_NAME/bin" \
        "/home/$USER_NAME/.local/" \
        "/home/$USER_NAME/.local/bin" \
        "/home/$USER_NAME/.local/share" \
        # ansible
        "/home/$USER_NAME/ansible/"

WORKDIR "/home/$USER_NAME/ansible/"

# ENV ANSIBLE_GATHERING smart
# ENV ANSIBLE_HOST_KEY_CHECKING false
# ENV ANSIBLE_RETRY_FILES_ENABLED false
# ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
# ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT ["ansible-playbook"]
