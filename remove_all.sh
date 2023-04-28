#!/bin/bash
n=$(cat $(pwd)/.nIOT)
docker stop $(docker ps -a -q)

docker network rm lighthouse-net
docker network rm master-net
for i in $(seq $n);do
    docker network rm iot-net-$i
done

rm -rfd iot-container/iot-dev-*
rm -rfd iot-master-container/iot-master-dev
rm -rfd lighthouse-container/lighthouse-dev

rm -f .nIOT