FROM mysql:8.0
LABEL maintainer="Julio Cesar <julio@blackdevs.com.br>"

RUN apt-get update -y && \
    apt-get install -y gettext curl vim

COPY data.sql /tmp/data.sql
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh

ENTRYPOINT ["/opt/docker-entrypoint.sh"]
# pass the original entrypoint as arguments
CMD ["/usr/local/bin/docker-entrypoint.sh", "mysqld", "--innodb-use-native-aio=0"]
