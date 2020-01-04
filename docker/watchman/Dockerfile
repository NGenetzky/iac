FROM node:8-alpine

# Install the packages required for watchman to work properly:
RUN apk add --no-cache libcrypto1.0 libgcc libstdc++

# Copy the watchman executable binary directly from our image:
COPY --from=icalialabs/watchman:4-alpine3.4 /usr/local/bin/watchman* /usr/local/bin/
# (Optional) Copy the compiled watchman documentation:
COPY --from=icalialabs/watchman:4-alpine3.4 /usr/local/share/doc/watchman* /usr/local/share/doc/

# Create the watchman STATEDIR directory:
RUN mkdir -p /usr/local/var/run/watchman \
    && touch /usr/local/var/run/watchman/.gitignore
