#!/bin/bash

set -eux
cd "$(dirname $0)"

java ${JAVA_OPT} -jar rocketmq-exporter.jar --spring.config.location=./application.yml
