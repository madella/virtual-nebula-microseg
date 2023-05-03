## Dockerfile for NEBULA lighthouse
FROM archlinux:latest

RUN pacman -Syy
RUN pacman -S --noconfirm nebula python net-tools

ADD lighthouse-dev /cert
# LIGHTHOUSE needs to expose only port for nebula itself.
EXPOSE 4242

ENTRYPOINT ["nebula", "-config", "/cert/config.yml"]