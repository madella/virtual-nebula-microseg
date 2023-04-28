#!/bin/bash
n=$(cat $(pwd)/.nIOT)
## LIGHTHOUSE
if [ $# -ge 1 ]; then
    docker kill iot-dev-$1 
    docker rm iot-dev-$1
    docker run -d -t --name iot-dev-$1 \
    --net iot-simulator    \
    --rm \
    --entrypoint /bin/bash \
    --privileged \
    --cap-add=NET_ADMIN \
    --device /dev/net/tun:/dev/net/tun\
    iot-dev:$1
    docker exec -it iot-dev-$1 /bin/bash
    exit 0
fi
docker kill lighthouse
docker run -d -t --name lighthouse \
    --rm \
    -e "HOSTNAME=lighthouse" \
    --net lighthouse-net --ip 172.20.0.100 \
    --cap-add=NET_ADMIN \
    --device /dev/net/tun:/dev/net/tun\
    lighthouse-dev

docker kill iot-master
docker run -d -t --name iot-master \
    --rm \
    -e "HOSTNAME=lighthouse" \
    --net master-net --ip 172.20.50.2 \
    --cap-add=NET_ADMIN \
    --device /dev/net/tun:/dev/net/tun\
    iot-master-dev

for i in $(seq $n);do
    docker kill iot-dev-$i #&& docker rm iot-dev:$i
    docker run -t -d --name iot-dev-$i \
     --net iot-net-$i \
     --rm \
     -e "HOSTNAME=iot$i" \
     --ip 172.20.$i.2 \
     --cap-add=NET_ADMIN \
     --device /dev/net/tun:/dev/net/tun\
     iot-dev:$i
     #--entrypoint /bin/bash \
done


## In order to simulat internet connection, we need to connect networks to each other with the following lines:
echo "Connecting iot-dev-s & master to lighthouse-net"
docker network connect lighthouse-net iot-master
for i in $(seq $n);do
    docker network connect lighthouse-net iot-dev-$i
done