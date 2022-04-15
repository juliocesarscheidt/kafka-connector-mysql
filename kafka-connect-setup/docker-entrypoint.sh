#!/bin/sh

echo "${KAFKA_CONNECT_URI}"

while [ "$(curl --silent -o /dev/null -L -w "%{http_code}" --url "${KAFKA_CONNECT_URI}/connectors")" != "200" ] ; do
  echo "[INFO] Sleeping..."
  sleep 5
done

function create_connector() {
  local CONNECTOR_NAME="${1}"
  local DATA="${2}"

  # list plugins
  curl --silent \
    -X GET \
    -H 'Content-Type: application/json' \
    "${KAFKA_CONNECT_URI}/connector-plugins" | jq -r .

  if [ ${FORCE_RECREATE} -eq 1 ]; then
    echo "Deleting connector ${CONNECTOR_NAME}"
    # delete connector
    curl --silent \
      -X DELETE \
      -H 'Content-Type: application/json' \
      "${KAFKA_CONNECT_URI}/connectors/${CONNECTOR_NAME}"
  fi

  # list connectors
  CONNECTORS="$(curl --silent \
    -X GET \
    -H 'Content-Type: application/json' \
    "${KAFKA_CONNECT_URI}/connectors")"

  echo "${CONNECTORS}" | jq -r .
  # CONNECTORS='["connector"]'

  CONNECTOR_EXISTS=$(echo "${CONNECTORS}" | jq -r --arg CONNECTOR_NAME "$CONNECTOR_NAME" '.[] | select(.==$CONNECTOR_NAME)')
  echo "CONNECTOR_EXISTS :: ${CONNECTOR_EXISTS}"

  if [ -z "${CONNECTOR_EXISTS}" ]; then
    echo "Creating connector ${CONNECTOR_NAME}"
    # create connector
    curl --silent \
      -X POST \
      -H 'Content-Type: application/json' \
      --data "${DATA}" \
      "${KAFKA_CONNECT_URI}/connectors"
  fi
}

# jdbc source connector
CONNECTOR_NAME="jdbc-connector-users"

DATA=$(cat << EOF
{
  "name": "${CONNECTOR_NAME}",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
    "connection.url": "jdbc:mysql://mysql:3306/kafka_database?allowPublicKeyRetrieval=true&useSSL=false",
    "connection.user": "debezium",
    "connection.password": "password",
    "tasks.max": "1",
    "topic.prefix": "${CONNECTOR_NAME}",
    "db.timezone": "America/Sao_Paulo",
    "errors.tolerance": "all",
    "errors.log.enable": "true",
    "errors.log.include.messages": "true",
    "poll.interval.ms": "5000",
    "reconnect.backoff.max.ms": "10000",
    "reconnect.backoff.ms": "5000",
    "retry.backoff.ms": "10000",
    "connection.attempts": "10",
    "numeric.mapping": "best_fit",
    "mode": "timestamp+incrementing",
    "incrementing.column.name": "id",
    "timestamp.column.name": "created_at",
    "schema.pattern": "kafka_database",
    "table.types": "TABLE",
    "query": "SELECT CAST(id AS UNSIGNED) AS id, name, email, password, created_at, updated_at, deleted_at FROM kafka_database.users",
    "validate.non.null": "false",
    "quote.sql.identifiers": "never"
  }
}
EOF
)

create_connector "${CONNECTOR_NAME}" "${DATA}"

# http sink connector
CONNECTOR_NAME="http-connector-api"

DATA=$(cat << EOF
{
  "name": "${CONNECTOR_NAME}",
  "config": {
    "topics": "jdbc-connector-users",
    "tasks.max": "1",
    "connector.class": "io.confluent.connect.http.HttpSinkConnector",
    "http.api.url": "http://api:5000/v1/users",
    "value.converter": "org.apache.kafka.connect.storage.StringConverter",
    "confluent.topic.bootstrap.servers": "kafka:9092",
    "confluent.topic.replication.factor": "1",
    "reporter.bootstrap.servers": "kafka:9092",
    "reporter.result.topic.name": "success-responses",
    "reporter.result.topic.replication.factor": "1",
    "reporter.error.topic.name":"error-responses",
    "reporter.error.topic.replication.factor":"1"
  }
}
EOF
)

create_connector "${CONNECTOR_NAME}" "${DATA}"

# The Kafka topics that this connector will be reading from must exist prior to starting the connector.
# rabbitmq sink connector
CONNECTOR_NAME="rabbitmq-connector-amqp"

DATA=$(cat << EOF
{
  "name": "${CONNECTOR_NAME}",
  "config": {
    "connector.class": "io.confluent.connect.rabbitmq.sink.RabbitMQSinkConnector",
    "tasks.max": "1",
    "topics": "jdbc-connector-users",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
    "confluent.topic.bootstrap.servers": "kafka:9092",
    "confluent.topic.replication.factor": "1",
    "rabbitmq.host": "rabbitmq",
    "rabbitmq.port": "5672",
    "rabbitmq.username": "rabbitmq",
    "rabbitmq.password": "admin",
    "rabbitmq.exchange": "rabbitmq_connector_exchange",
    "rabbitmq.routing.key": "rabbitmq_connector",
    "rabbitmq.delivery.mode": "PERSISTENT"
  }
}
EOF
)

create_connector "${CONNECTOR_NAME}" "${DATA}"

exit 0