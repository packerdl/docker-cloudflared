ARG ARCH=amd64
FROM golang:alpine AS builder

ARG GOARCH=amd64
ARG GOARM

RUN apk --no-cache add git build-base \
  && go get -v github.com/cloudflare/cloudflared/cmd/cloudflared

WORKDIR /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared

RUN DATE=$(date -u '+%Y-%m-%d-%H%M UTC') \
  VERSION=$(git describe --tags --always --dirty='-dev') \
  && GOOS=linux GOARCH=${GOARCH} GOARM=${GOARM} \
       go build -v -ldflags="-X 'main.Version=$VERSION' -X 'main.BuildTime=$DATE'" ./


FROM multiarch/alpine:${ARCH}-latest-stable

RUN apk --no-cache add bind-tools ca-certificates \
  && adduser -S cloudflared

COPY --from=builder \
  /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared/cloudflared \
  /usr/local/bin/cloudflared

USER cloudflared
ENTRYPOINT ["cloudflared"]
