FROM ubuntu:18.04 as base-0

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
        apt-utils \
        dialog \
    # Basic tools
    && apt-get install -y \
        etckeeper \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*


