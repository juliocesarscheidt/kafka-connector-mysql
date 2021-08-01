# Kafka Connector

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

## Access

> Connector
<http://localhost:8083/connectors>

> Kafka Connect
<http://localhost:9021/>
