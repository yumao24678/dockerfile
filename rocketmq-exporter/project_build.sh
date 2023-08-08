#!/bin/bash

set -eux
cd "$(dirname $0)"

GIT_URL="https://github.com/apache/rocketmq-exporter.git"
PROJECT_DIR="rocketmq-exporter"
BUILD_IMAGE="maven:3.8.6-openjdk-11"

rm -rf ./src
mkdir -p ./src
cd ./src

git clone "$GIT_URL"
cd "$PROJECT_DIR"

sed -i.bak -r \
    -e "s/getTransferredTps/getTransferedTps/g" \
    src/main/java/org/apache/rocketmq/exporter/model/BrokerRuntimeStats.java

# sed -i.bak -r \
#     -e "s/4.9.4/4.5.0/g" \
#     pom.xml

cd ../

docker run --rm \
    --network=host \
    --workdir=/$PROJECT_DIR \
    -v /data/maven_localrepo:/root/.m2 \
    -v $(pwd)/$PROJECT_DIR:/$PROJECT_DIR \
    --entrypoint=/bin/bash \
    "$BUILD_IMAGE" \
    -c "mvn clean package -Dmaven.test.skip=true"

cd ../

rm -rf *.jar *.yml

cp -a ./src/"$PROJECT_DIR"/target/*-exec.jar ./
cp -a ./src/"$PROJECT_DIR"/src/main/resources/application.yml ./

sed -r -i.bak \
    -e "s/127.0.0.1:9876/\${NAMESRV:127.0.0.1:9876}/g" \
    -e "s/4_9_4/4_5_0/g" \
    ./application.yml
