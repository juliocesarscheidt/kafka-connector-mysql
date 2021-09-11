FROM golang:1.16 as builder
LABEL maintainer="Julio Cesar <julio@blackdevs.com.br>"

WORKDIR /go/src/app

COPY go.mod go.sum /go/src/app/
RUN go mod download

COPY main.go /go/src/app/main.go

RUN GOOS=linux GOARCH=amd64 GO111MODULE=on CGO_ENABLED=0 go build -o /go/src/app/main .

FROM gcr.io/distroless/static:nonroot

WORKDIR /
COPY --from=builder /go/src/app/main .
USER nonroot:nonroot

EXPOSE 5000

ENTRYPOINT [ "/main" ]
