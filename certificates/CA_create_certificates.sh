#!/bin/bash
echo "CA autority working on sing for each node"
FILE=./ca.key
if [ -f "$FILE" ]; then
    echo "$FILE already exists... skipping this part"
else 
    nebula-cert ca -name \"iot-microseg-project\"
    if [ $? -eq 1 ]; then
        echo "Error on CA-cert creation."
        exit 1
    fi
fi

nebula-cert sign -name "lighthouse" -ip "192.168.100.1/24" -groups "lighthouse"
mkdir "lighthouse-dev"
mv lighthouse.* ./lighthouse-dev
cp ca.crt ./lighthouse-dev
cp lighthouse-default.yml ./lighthouse-dev/config.yml
mv ./lighthouse-dev ../lighthouse-container/

nebula-cert sign -name "iot-master" -ip "192.168.100.50/24" -groups "iot-masters"
mkdir "iot-master-dev"
mv iot-master.* ./iot-master-dev
cp ca.crt ./iot-master-dev
cp master-default.yml ./iot-master-dev/config.yml
mv ./iot-master-dev ../iot-master-container/

n=$1
for i in $(seq $n);do
    echo "HOST 192.168.100.$i]"
    if [ $i -eq 1 ]; then
        inew=$(expr $n + 1 )
        nebula-cert sign -name "iot-dev-$i" -ip "192.168.100.$inew/24" -groups "iot-devs"
    else
        nebula-cert sign -name "iot-dev-$i" -ip "192.168.100.$i/24" -groups "iot-devs"
    fi
    mkdir "iot-dev-$i"
    mv iot-dev-$i.crt ./iot-dev-$i/iot-dev.crt
    mv iot-dev-$i.key ./iot-dev-$i/iot-dev.key
    cp ca.crt ./iot-dev-$i
    cp iot-default.yml ./iot-dev-$i/config.yml
    mv ./iot-dev-$i ../iot-container/
done