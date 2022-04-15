#!/bin/bash

set -ex

/rabbitmq-config.sh &
/usr/local/bin/docker-entrypoint.sh "$@"
