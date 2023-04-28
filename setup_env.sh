#!/bin/bash
number=.nIOT
USAGE="Usage: $0 #of-iot-devs"
if [ $# -lt 1 ]; then 
    echo $USAGE
    exit 1
fi

case $1 in
    ''|*[!0-9]*) echo $USAGE; exit 2;;
    *) echo $1 > $number;;
esac

## Setup docker networks
docker network create --driver=bridge --subnet=172.20.0.0/24 lighthouse-net
docker network create --driver=bridge --subnet=172.20.50.0/24 master-net
for i in $(seq $1);do
    docker network create --driver=bridge --subnet=172.20.$i.0/24 iot-net-$i
done

## Run CA_create
cd certificates/
./CA_create_certificates.sh $1

## Build Everything
cd ..
./build_containers.sh

## Run everything
./run_containers.sh