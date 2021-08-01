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

# go mod init github.com/juliocesarscheidt/api
# go mod tidy

# docker image build --tag api:latest -f Dockerfile .
# docker container run --name api -p 5000:5000 api:latest

# curl -X POST \
#   -H 'Content-type: application/json' \
#   --data '{"id": 4000, "name": "teste", "email": "teste@mail.com", "password": "password", "created_at": "2021-08-01 00:00:00", "updated_at": "", "deleted_at": ""}' \
#   'http://localhost:5000/v1/users'
