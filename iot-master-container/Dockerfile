## Dockerfile for NEBULA lighthouse
FROM archlinux:latest

RUN pacman -Syy
RUN pacman -S --noconfirm nebula python netcat

ADD iot-master-dev /cert

WORKDIR /iot-simulator
ADD entrypoint.sh ./
ADD server_multithread.py ./

EXPOSE 4242
# MQTT port used for my example of iot-device
EXPOSE 1883

ENTRYPOINT ["/iot-simulator/entrypoint.sh"]
