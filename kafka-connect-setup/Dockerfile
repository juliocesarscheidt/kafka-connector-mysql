FROM alpine:3.10
LABEL maintainer="Julio Cesar <julio@blackdevs.com.br>"

RUN apk update && \
    apk add curl jq --no-cache

COPY docker-entrypoint.sh /opt/docker-entrypoint.sh

ENTRYPOINT ["/opt/docker-entrypoint.sh"]
