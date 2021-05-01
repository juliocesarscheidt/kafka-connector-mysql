#!/bin/bash

sleep 10

OLD_IFS="$IFS"
IFS=","

for TOPIC in $TOPICS; do
  kafka-topics \
    --zookeeper $KAFKA_ZOOKEEPER_CONNECT --create \
    --topic $TOPIC \
    --partitions 1 \
    --replication-factor 1 \
    --if-not-exists
done

IFS="$OLD_IFS"

kafka-topics \
  --zookeeper $KAFKA_ZOOKEEPER_CONNECT \
  --list | egrep -v '^_'

exit 0
