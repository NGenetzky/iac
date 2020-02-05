
# https://github.com/phusion/passenger-docker
FROM phusion/passenger-customizable:1.0.9

# Set correct environment variables.
ENV HOME /root

# Use phusion/baseimage-docker's init process.
# TODO: Should I use CMD or ENTRYPOINT?
CMD ["/sbin/my_init"]
# ENTRYPOINT ["/sbin/my_init"]

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features.
RUN /pd_build/python.sh
RUN /pd_build/nodejs.sh
