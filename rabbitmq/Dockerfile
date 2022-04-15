FROM rabbitmq:3.9-management

LABEL maintainer="Julio Cesar <julio@blackdevs.com.br>"

RUN apt-get update -yqq && \
    apt-get install -yqq \
    wget unzip netcat && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY rabbitmq-config.sh /rabbitmq-config.sh
COPY rabbitmq-entrypoint.sh /rabbitmq-entrypoint.sh

RUN rabbitmq-plugins enable rabbitmq_stream

ENTRYPOINT ["/bin/bash", "/rabbitmq-entrypoint.sh"]
CMD "rabbitmq-server"
