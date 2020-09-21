FROM golang:alpine as builder

WORKDIR /tun2socks-src
COPY . /tun2socks-src

RUN apk add --update --no-cache \
    gcc git make musl-dev \
    && go mod download \
    && go get -u github.com/gobuffalo/packr/packr \
    && packr \
    && make build \
    && /tun2socks-src/bin/tun2socks -version

FROM alpine:latest

COPY ./tun2socks.sh /
COPY --from=builder /tun2socks-src/bin/tun2socks /tun2socks

RUN apk add --update --no-cache iptables iproute2 \
    && chmod +x /tun2socks.sh

ENV TUN tun0
ENV ETH eth0
ENV ETH_ADDR=
ENV TUN_ADDR=
ENV TUN_MASK=
ENV PROXY=
ENV LOGLEVEL=
ENV EXCLUDED=
ENV EXTRACMD=
ENV MONITOR=
ENV MONITOR_ADDR=
ENV FAKEDNS=
ENV BACKEND_DNS=
ENV HOSTS=

ENTRYPOINT ["/tun2socks.sh"]
