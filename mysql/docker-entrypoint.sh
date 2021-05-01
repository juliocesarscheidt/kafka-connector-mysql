#!/bin/bash

cat /tmp/data.sql | envsubst \${DEBEZIUM_USER},\${DEBEZIUM_PASS} | tee /docker-entrypoint-initdb.d/data.sql
cat /docker-entrypoint-initdb.d/data.sql

exec "$@"
