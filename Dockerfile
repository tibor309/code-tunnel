FROM ghcr.io/linuxserver/baseimage-ubuntu:noble

# set labels
ARG IMAGE_BUILD_DATE
LABEL maintainer="tibor309"
LABEL release_channel="stable"
LABEL org.opencontainers.image.authors="Tibor (https://github.com/tibor309)"
LABEL org.opencontainers.image.created="${IMAGE_BUILD_DATE}"
LABEL org.opencontainers.image.title="VS Code Tunnel"
LABEL org.opencontainers.image.description="VS Code Tunnel inside a Docker container."
LABEL org.opencontainers.image.source="https://github.com/tibor309/code-tunnel"
LABEL org.opencontainers.image.url="https://github.com/tibor309/code-tunnel/packages"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.documentation="https://github.com/tibor309/code-tunnel/blob/main/README.md"
LABEL org.opencontainers.image.base.name="ghcr.io/linuxserver/baseimage-ubuntu:noble"
LABEL org.opencontainers.image.base.documentation="https://github.com/linuxserver/docker-baseimage-ubuntu/blob/master/README.md"

# branding
ENV LSIO_FIRST_PARTY=false

# set default tunnel name
ENV TUNNEL_NAME="code-tunnel"

ENV VSCODE_CLI_DATA_DIR="/config/data"
ENV VSCODE_AGENT_FOLDER="/config/data"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

RUN \
  echo "**** install runtime dependencies ****" && \
  apt-get update && \
  apt-get install -y \
    git \
    gh \
    libatomic1 \
    nano \
    net-tools \
    curl \
    sudo && \
  echo "**** install packages ****" && \
  curl -vSLo \
    /etc/apt/keyrings/packages.microsoft.asc \
    https://packages.microsoft.com/keys/microsoft.asc && \
  echo \
    "deb [signed-by=/etc/apt/keyrings/packages.microsoft.asc] https://packages.microsoft.com/repos/code stable main" \
    > /etc/apt/sources.list.d/microsoft.list && \
  apt-get update -y && \
  apt-get install --no-install-recommends -y \
    code && \
  echo "**** clean up ****" && \
  apt-get clean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /
