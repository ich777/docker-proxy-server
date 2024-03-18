FROM golang:1.22-alpine AS builder

WORKDIR /tmp

RUN apk update &&\
  apk add git && \
  git clone https://github.com/SenseUnit/dumbproxy /tmp/dumbproxy  &&\
  git clone https://github.com/ich777/socks5 /tmp/socks5

RUN cd /tmp/dumbproxy/ && \
  sed -i 's|Basic realm="dumbproxy"|Basic realm="Please authenticate"|' /tmp/dumbproxy/auth.go
  go get && \
  go build

RUN cd /tmp/socks5 && \
  go get && \
  go build

RUN mkdir -p /tmp/bin && \
  mv /tmp/dumbproxy/dumbproxy /tmp/bin/proxy && \
  mv /tmp/socks5/socks5 /tmp/bin/socks5 && \
  rm -rf /tmp/dumbproxy /tmp/socks5

FROM ich777/debian-baseimage

COPY --from=builder /tmp/bin/ /usr/bin/

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-proxy-server"

RUN apt-get update && \
	apt-get -y install --no-install-recommends jq && \
	rm -rf /var/lib/apt/lists/*

ENV HTTP_PROXY="true"
ENV HTTP_PROXY_PORT=8118
ENV HTTP_PROXY_USER=""
ENV HTTP_PROXY_PWD=""
ENV SOCKS5_PROXY="true"
ENV SOCKS5_PROXY_PORT=1080
ENV SOCKS5_PROXY_USER=""
ENV SOCKS5_PROXY_PWD=""
ENV USER="proxy_server"
ENV UID=99
ENV GID=100
ENV UMASK=0000

RUN mkdir /$USER && \
  useradd -d /$USER -s /bin/bash $USER

ADD /scripts/ /opt/scripts/
ADD /urlencode /usr/bin/urlencode
RUN chmod -R 770 /opt/scripts/ && \
  chmod 755 /usr/bin/urlencode

ENTRYPOINT ["/opt/scripts/start.sh"]
