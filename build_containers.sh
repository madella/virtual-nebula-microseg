#!/bin/bash
cd lighthouse-container
echo "lighthouse BUILDING:"
docker build -t lighthouse-dev .

cd ../iot-master-container
echo "iot-master BUILDING:"
docker build -t iot-master-dev .

cd ..
n=$(cat $(pwd)/.nIOT)
echo "IOT-dev-BUILDING:"
cd iot-container

for i in $(seq $n);do
    docker build --build-arg CERT=iot-dev-$i -t iot-dev:$i .
done

