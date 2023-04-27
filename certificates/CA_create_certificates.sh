#!/bin/bash

# This is my script that generate if wanted a lot of iot-dev

echo "CA autority working on sing for each node"
FILE=./ca.key
if [ -f "$FILE" ]; then
    echo "$FILE already exists... skipping this part"
else 
    nebula-cert ca -name \"iot-microseg-inf\"
    if [ $? -eq 1 ]; then
        echo "Error on CA-cert creation."
        exit 1
    fi
fi

for i in {2..4..1}; do
    echo "HOST 192.168.100.$i]"
    nebula-cert sign -name "iot-dev-$i" -ip "192.168.100.$i/24"
    mkdir "iot-dev-$i"
    mv iot-dev-$i.* ./iot-dev-$i
done