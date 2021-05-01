FROM golang:1.16 as builder
LABEL maintainer="Julio Cesar <julio@blackdevs.com.br>"

WORKDIR /go/src/app

RUN apt-get update -yqq && \
    apt-get install -yqq build-essential pkg-config git curl

COPY go.mod go.sum /go/src/app/
RUN go mod download

COPY main.go /go/src/app/main.go

ENV GOOS=linux
ENV GOARCH=amd64
ENV GO111MODULE=on
# this cause issues with kafka
# ENV CGO_ENABLED=0

ENTRYPOINT [ "go", "run", "/go/src/app/main.go" ]
