#!/bin/bash

sleep 10

while true; do
  sleep 5
  rabbitmq-diagnostics -q ping > /dev/null 2>&1
  test $? == 0 && break
done

rabbitmqctl add_user "${RABBITMQ_USERNAME}" "${RABBITMQ_PASSWORD}"

rabbitmqctl set_user_tags "${RABBITMQ_USERNAME}" administrator
rabbitmqctl set_permissions -p "/" "${RABBITMQ_USERNAME}" ".*" ".*" ".*"
rabbitmqctl set_permissions -p "/" guest ".*" ".*" ".*"

# setup
rabbitmqadmin declare --vhost="/" queue name="rabbitmq_connector_queue" auto_delete=false durable=true
rabbitmqadmin declare --vhost="/" exchange name="rabbitmq_connector_exchange" type=direct auto_delete=false durable=true
rabbitmqadmin declare --vhost="/" binding source="rabbitmq_connector_exchange" destination="rabbitmq_connector_queue" routing_key="rabbitmq_connector" destination_type=queue
