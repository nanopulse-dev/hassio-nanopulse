FROM ghcr.io/home-assistant/base:latest

ENV APP_VERSION=0.1.0-test.1

RUN \
  set -x && \
  apkArch="$(apk --print-arch)"; \
  case "$apkArch" in \
    aarch64) export ARCH='arm64' ;; \
    x86_64) export ARCH='amd64' ;; \
  esac; \
  mkdir -p /nanopulse-gateway && \
  cd /nanopulse-gateway && \
  wget https://dl.nanopulse.dev/downloads/nanopulse-gateway/nanopulse-gateway_$APP_VERSION.$ARCH.tar.gz && \
  tar zxf nanopulse-gateway_$APP_VERSION.$ARCH.tar.gz && \
  rm nanopulse-gateway_$APP_VERSION.$ARCH.tar.gz

COPY run.sh /
COPY nanopulse-gateway.toml /nanopulse-gateway/config/nanopulse-gateway.toml
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
