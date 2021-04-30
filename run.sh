#!/bin/bash

docker-compose up -d mysql

sleep 10

docker-compose up -d zookeeper

sleep 10

docker-compose up -d kafka

sleep 10

docker-compose up -d kafka-boot

sleep 10

docker-compose up -d kafka-connect

sleep 10

docker-compose up -d control-center
