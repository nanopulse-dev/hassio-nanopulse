FROM ghcr.io/home-assistant/base:latest

ENV APP_VERSION=0.1.0-test.1

RUN \
  set -x && \
  apkArch="$(apk --print-arch)"; \
  case "$apkArch" in \
    aarch64) export ARCH='arm64' ;; \
    x86_64) export ARCH='amd64' ;; \
  esac; \
  mkdir -p /nanopulse-server && \
  cd /nanopulse-server && \
  wget https://dl.nanopulse.dev/downloads/nanopulse-server/nanopulse-server-sqlite_$APP_VERSION.$ARCH.tar.gz && \
  tar zxf nanopulse-server-sqlite_$APP_VERSION.$ARCH.tar.gz && \
  rm nanopulse-server-sqlite_$APP_VERSION.$ARCH.tar.gz

RUN \
  set -x && \
  apk add --no-cache --virtual .build-dependencies git && \
  cd /nanopulse-server && \
  git clone -b devel https://github.com/nanopulse-dev/nanopulse-profiles.git profiles && \
  apk del --no-cache  .build-dependencies

COPY run.sh /
COPY nanopulse-server.toml /nanopulse-server/config/nanopulse-server.toml
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
