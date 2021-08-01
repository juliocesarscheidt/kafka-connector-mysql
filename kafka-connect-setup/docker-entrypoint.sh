#!/bin/sh

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



CONNECTOR_NAME="jdbc-connector-users"

DATA=$(cat << EOF
{
  "name": "$CONNECTOR_NAME",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
    "connection.url": "jdbc:mysql://mysql:3306/kafka_database?useSSL=false",
    "connection.user": "$DEBEZIUM_USER",
    "connection.password": "$DEBEZIUM_PASS",
    "tasks.max": "1",
    "topic.prefix": "$CONNECTOR_NAME",
    "db.timezone": "America/Sao_Paulo",
    "errors.tolerance": "all",
    "errors.log.enable": "true",
    "errors.log.include.messages": "true",
    "poll.interval.ms": "30000",
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



CONNECTOR_NAME="mysql-connector"
# mysql_namespace.kafka_database.*

DATA=$(cat << EOF
{
  "name": "$CONNECTOR_NAME",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "database.hostname": "mysql",
    "database.port": "3306",
    "database.user": "$DEBEZIUM_USER",
    "database.password": "$DEBEZIUM_PASS",
    "tasks.max": "1",
    "database.server.name": "mysql_namespace",
    "database.include.list": "kafka_database",
    "database.history.kafka.bootstrap.servers": "kafka:9092",
    "database.history.kafka.topic": "history.kafka_database",
    "database.ssl.mode": "disabled",
    "database.allowPublicKeyRetrieval": "true",
    "include.schema.changes": "true"
  }
}
EOF
)

create_connector "${CONNECTOR_NAME}" "${DATA}"

exit 0
