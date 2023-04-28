#!/bin/bash
n=$(cat $(pwd)/.nIOT)
## LIGHTHOUSE
docker kill lighthouse
docker run -d -t --name lighthouse \
    --rm \
    -e "HOSTNAME=lighthouse" \
    --net lighthouse-net --ip 172.20.0.100 \
    --cap-add=NET_ADMIN \
    --device /dev/net/tun:/dev/net/tun\
    lighthouse-dev
## iot-master
docker kill iot-master
docker run -d -t --name iot-master \
    --rm \
    -e "HOSTNAME=iot-master" \
    --net master-net --ip 172.20.50.2 \
    --cap-add=NET_ADMIN \
    --device /dev/net/tun:/dev/net/tun\
    iot-master-dev
## iot-devs
for i in $(seq $n);do
    docker kill iot-dev-$i
    docker run -t -d --name iot-dev-$i \
     --net iot-net-$i \
     --rm \
     -e "HOSTNAME=iot$i" \
     --cap-add=NET_ADMIN \
     --device /dev/net/tun:/dev/net/tun\
     iot-dev:$i
     #--ip 172.20.$i.2 \
done

#### IMPORTANT ####
## In order to simulat internet connection, 
## we need to connect all networks to lighthouse "physical" network (lighthouse-net)
## with the following lines:
echo "Connecting iot-dev-s & master to lighthouse-net"
for i in $(seq $n);do
    docker network connect lighthouse-net iot-dev-$i
done
docker network connect lighthouse-net iot-master
