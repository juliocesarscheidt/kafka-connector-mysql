FROM confluentinc/cp-kafka-connect-base:6.0.0
LABEL maintainer="Julio Cesar <julio@blackdevs.com.br>"

ENV CONNECT_PLUGIN_PATH: "/usr/share/java,/data/connectors,/usr/share/confluent-hub-components"

RUN confluent-hub install --no-prompt hpgrahsl/kafka-connect-mongodb:1.1.0 \
  && confluent-hub install --no-prompt debezium/debezium-connector-mysql:1.5.0 \
  && confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:11.0.0 \
  && confluent-hub install --no-prompt jcustenborder/kafka-connect-json-schema:0.2.5 \
  && confluent-hub install --no-prompt confluentinc/kafka-connect-http:1.0.3 \
  && confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.0.0

# user root

# RUN curl --silent -L --output mysql-connector-java-8.0.26-1.el8.noarch.rpm https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-8.0.26-1.el8.noarch.rpm
# RUN rpm --checksig mysql-connector-java-8.0.26-1.el8.noarch.rpm
# RUN rpm -i -f mysql-connector-java-8.0.26-1.el8.noarch.rpm

COPY --chown=1000:1000 kafka-connect.properties /etc/kafka/connect-standalone.properties
RUN chmod 444 /etc/kafka/connect-standalone.properties
RUN ls -lth /etc/kafka/
# COPY kafka-connect.properties /etc/kafka/connect-distributed.properties

# copy mysql driver in order for plugin to work
COPY ./mysql-connector-java-8.0.13.jar /usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/lib/

# RUN ls -lth /usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/lib/

CMD ["/etc/confluent/docker/run"]
# connect-distributed /etc/kafka/connect-distributed.properties
