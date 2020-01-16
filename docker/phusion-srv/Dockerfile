# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-customizable:1.0.9

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
ENTRYPOINT ["/sbin/my_init"]

RUN rm -f \
    /etc/service/nginx/down \
    /etc/service/sshd/down

VOLUME [ "/root/.ssh/.authorized_keys" ]
