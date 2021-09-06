FROM confluentinc/cp-kafka-connect-base:6.0.0
LABEL maintainer="Julio Cesar <julio@blackdevs.com.br>"

RUN confluent-hub install --no-prompt hpgrahsl/kafka-connect-mongodb:1.1.0 \
  && confluent-hub install --no-prompt debezium/debezium-connector-mysql:1.5.0 \
  && confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:11.0.0 \
  && confluent-hub install --no-prompt jcustenborder/kafka-connect-json-schema:0.2.5 \
  && confluent-hub install --no-prompt confluentinc/kafka-connect-http:1.0.3 \
  && confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.0.0

USER root
RUN yum install -y gettext curl

# copy mysql jar file
COPY --chown=1000:1000 ./mysql-connector-java-8.0.13.jar /usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/lib/

# copy properties file
COPY --chown=1000:1000 kafka-connect.properties /tmp/connect-distributed.properties

ARG BOOTSTRAP_SERVERS
ENV BOOTSTRAP_SERVERS=$BOOTSTRAP_SERVERS

RUN cat /tmp/connect-distributed.properties | envsubst \${BOOTSTRAP_SERVERS} | tee /etc/kafka/connect-distributed.properties

RUN rm -f /tmp/connect-distributed.properties
RUN chmod 444 /etc/kafka/connect-distributed.properties

USER appuser
EXPOSE 8083

ENTRYPOINT ["/usr/bin/connect-distributed", "/etc/kafka/connect-distributed.properties"]
