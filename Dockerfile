FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy

# set labels
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version: ${VERSION} Build-date: ${BUILD_DATE}"
LABEL maintainer="tibor309"
LABEL org.opencontainers.image.description="VSCode Tunnel inside a docker container."
LABEL org.opencontainers.image.source=https://github.com/tibor309/code-tunnel
LABEL org.opencontainers.image.url=https://github.com/tibor309/code-tunnel/packages
LABEL org.opencontainers.image.licenses=GPL-3.0

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config"
ENV TUNNEL_NAME="code-tunnel"

RUN \
  echo "**** install runtime dependencies ****" && \
  apt-get update && \
  apt-get install -y \
    git \
    gh \
    jq \
    libatomic1 \
    nano \
    net-tools \
    netcat \
    curl \
    sudo && \
  echo "**** install vscode-cli ****" && \
  mkdir -p /app/vscode_cli && \
  curl --cipher ALL -o \
    /tmp/vscode_cli.tar.gz -L \
    "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64" && \
  tar -xf /tmp/vscode_cli.tar.gz -C \
    /app/vscode_cli && \
  echo "**** clean up ****" && \
  apt-get clean && \
  rm -rf \
    /config/* \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY /root /
