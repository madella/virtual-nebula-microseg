#!/bin/bash

# DEBUG
if [ $# -ge 1 ]; then # In order to run single io to debug. Ignore this
    docker kill iot-dev-$1 
    docker rm iot-dev-$1
    docker run -d -t --name iot-dev-$1 \
    --net iot-simulator    \
    --rm \
    --volume ./utils:/utils \
    --entrypoint /bin/bash \
    --privileged \
    --cap-add=NET_ADMIN \
    --device /dev/net/tun:/dev/net/tun\
    iot-dev:$1
    docker exec -it iot-dev-$1 /bin/bash
    exit 0
fi

## LIGHTHOUSE
docker kill lighthouse
docker run -d -t --name lighthouse \
    --rm \
    -e "HOSTNAME=lighthouse" \
    --net iot-simulator --ip 172.20.0.100 \
    --cap-add=NET_ADMIN \
    --volume ./utils:/utils \
    --device /dev/net/tun:/dev/net/tun\
    lighthouse-dev

## IOT-MASTER
docker kill iot-master
docker run -d -t --name iot-master \
    --rm \
    -e "HOSTNAME=lighthouse" \
    --net iot-simulator --ip 172.20.0.50 \
    --cap-add=NET_ADMIN \
    --volume ./utils:/utils \
    --device /dev/net/tun:/dev/net/tun\
    iot-master-dev

## IOT-DEVS
for i in {2..4..1}; do
    docker kill iot-dev-$i #&& docker rm iot-dev:$i
    docker run -t -d --name iot-dev-$i \
     --net iot-simulator \
     --rm \
     -e "HOSTNAME=iot$i" \
     --volume ./utils:/utils \
     --ip 172.20.0.$i \
     --cap-add=NET_ADMIN \
     --device /dev/net/tun:/dev/net/tun\
     iot-dev:$i
done