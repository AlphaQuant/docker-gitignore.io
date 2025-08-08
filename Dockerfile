FROM docker.io/library/debian:bookworm-20250721 AS src

COPY libs/gitignore /gitignore
COPY libs/gitignore.io /gitignore.io

RUN mkdir -p /gitignore.io/gitignore/templates/ \
    && find /gitignore -name '*.gitignore' -exec cp -rpf {} /gitignore.io/gitignore/templates/ \;

# Build swift backend
FROM docker.io/library/swift:5.6-focal AS swift-builder

COPY --from=src /gitignore.io /gitignore.io

WORKDIR /gitignore.io

RUN set -ex \
    && apt update \
    && apt install libssl-dev -y \
    && swift package clean \
    && swift package update \
    && swift build -Xswiftc -static-stdlib -j $(nproc) -c release \
    && mv $(swift build -Xswiftc -static-stdlib -c release --show-bin-path)/Run /tmp/Run

# Build node frontend
FROM docker.io/library/node:22.18.0 AS node-builder

COPY --from=src /gitignore.io /gitignore.io

WORKDIR /gitignore.io

RUN set -ex \
    && yarn install \
    && yarn build \
    && rm -rf node_modules

# Build final image
FROM docker.io/library/debian:bookworm-20250721 AS dest

WORKDIR /app

# The environment variable is set to empty(use the default value)
ARG HOST_ORIGIN
ARG BASE_PREFIX
ARG GOOGLE_ANALYTICS_UID

# Copy the project and remove the node frontend
COPY --from=src /gitignore.io /app

# Install some necessary dependencies
RUN set -ex \
    && apt update \
    && apt install git ca-certificates libcurl4 dumb-init --no-install-recommends -y \
    && rm -rf /app/Public /app/Resources \
    && apt autoremove -y \
    && apt autoclean -y

# Copy all newly compiled files to the final image
COPY --from=swift-builder /tmp/Run /app/Run
COPY --from=node-builder /gitignore.io/Public /app/Public
COPY --from=node-builder /gitignore.io/Resources /app/Resources

EXPOSE 8080/tcp

# Add dump-init to ensure container can respond to exit signals
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# System signals are taken over by dump-init, we can use `exec` to execute
# commands without worrying about signal forwarding and zombie processes
# See Also: https://docs.docker.com/engine/reference/builder/#cmd
CMD ["/app/Run", "serve", "-e", "prod", "-b", "0.0.0.0"]
