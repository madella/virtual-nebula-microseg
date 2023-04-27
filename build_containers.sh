#!/bin/bash
## BUILD lighthouse
cd lighthouse-container
echo "lighthouse BUILDING:"
docker build -t lighthouse-dev .
## BUILD iot-master
cd ../iot-master-container
echo "iot-master BUILDING:"
docker build -t iot-master-dev .
## BUILD iot-dev
echo "IOT-dev-BUILDING:"
cd ../iot-container
for i in {2..4..1}; do
    docker build --build-arg CERT=iot-dev-$i -t iot-dev:$i .
done

