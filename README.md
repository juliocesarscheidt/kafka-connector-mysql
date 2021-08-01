# Kafka Connector Project

In this project, there will be a MySQL database running as datasource, a Kafka node, a Kafka Connect node where there will be two connectors, one source and one sink, also an API as destination.

The source connector retrieves data from MySQL on incremental mode, and the sink connector gets from the Kafka's topic and sends to an API.

## Access

> Connector
<http://localhost:8083/connectors>

> Kafka Connect
<http://localhost:9021/>

## Commands

```bash
docker-compose up -d --build mysql
# docker-compose logs -f mysql
sleep 10

# docker-compose up -d elasticsearch
# sleep 10

docker-compose up -d zookeeper kafka
# docker-compose logs -f zookeeper kafka
sleep 10


# API for sink
docker-compose up -d --build api
# docker-compose logs -f api
sleep 10


docker-compose up -d --build kafka-connect
# docker-compose logs -f kafka-connect
sleep 10

docker-compose up -d --build kafka-connect-setup
# docker-compose logs -f kafka-connect-setup
sleep 10

docker-compose up -d control-center
# docker-compose logs -f control-center
sleep 10


# clients
docker-compose up -d --build producer
# docker-compose logs -f producer
sleep 10

docker-compose up -d --build consumer
# docker-compose logs -f consumer
sleep 10

```
