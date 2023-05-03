## Dockerfile for IOT-simulation object
FROM archlinux:latest

RUN pacman -Syy
RUN pacman -S --noconfirm nebula python net-tools traceroute netcat

# In order to give every iot-client autonomosly the right nebula config file 
# (since every iot-dev has their own folder)
ARG CERT
ADD $CERT /cert

WORKDIR /iot-simulator
ADD entrypoint.sh ./
ADD client.py ./

EXPOSE 4242

ENTRYPOINT ["/iot-simulator/entrypoint.sh"]