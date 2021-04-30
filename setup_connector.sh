#!/bin/bash

DATA=$(cat << EOF
{
  "name": "connector",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1",
    "database.hostname": "mysql",
    "database.port": "3306",
    "database.user": "debezium",
    "database.password": "DEBEZIUM_PASSWORD",
    "database.server.name": "mysql-namespace",
    "database.include.list": "kafka_database",
    "table.include.list": "users",
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
docker exec -it kafka-connect curl \
  -X GET \
  -H 'Content-Type: application/json' \
  http://kafka-connect:8083/connector-plugins | jq -r .

# list connectors
docker exec -it kafka-connect curl \
  -X GET \
  -H 'Content-Type: application/json' \
  http://kafka-connect:8083/connectors

# delete
# docker exec -it kafka-connect curl \
#   -X DELETE \
#   -H 'Content-Type: application/json' \
#   http://kafka-connect:8083/connectors/connector

# create connector
docker exec -it kafka-connect curl \
  -X POST \
  -H 'Content-Type: application/json' \
  --data "${DATA}" \
  http://kafka-connect:8083/connectors
