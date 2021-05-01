#!/bin/sh

CONNECTOR_NAME="connector"

DATA=$(cat << EOF
{
  "name": "$CONNECTOR_NAME",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1",
    "database.hostname": "mysql",
    "database.port": "3306",
    "database.user": "$DEBEZIUM_USER",
    "database.password": "$DEBEZIUM_PASS",
    "database.server.name": "mysql_namespace",
    "database.include.list": "kafka_database",
    "database.history.kafka.bootstrap.servers": "kafka:9092",
    "database.ssl.mode": "disabled",
    "database.allowPublicKeyRetrieval": "true",
    "include.schema.changes": "true",
    "database.history.kafka.topic": "history.kafka_database"
  }
}
EOF
)

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

exit 0
