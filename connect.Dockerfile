FROM confluentinc/cp-kafka-connect-base:6.0.0

ENV CONNECT_PLUGIN_PATH: "/usr/share/java,/data/connectors,/usr/share/confluent-hub-components"

RUN confluent-hub install --no-prompt hpgrahsl/kafka-connect-mongodb:1.1.0 \
  && confluent-hub install --no-prompt microsoft/kafka-connect-iothub:0.6 \
  && confluent-hub install --no-prompt wepay/kafka-connect-bigquery:1.1.0 \
  && confluent-hub install --no-prompt debezium/debezium-connector-mysql:1.5.0 \
  && confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:11.0.0 \
  && confluent-hub install --no-prompt jcustenborder/kafka-connect-json-schema:0.2.5

CMD ["/etc/confluent/docker/run"]
