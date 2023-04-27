# Project Work On Cybersecurity (3CFU)

Mettere in piedi un ambiente di test moderatamente complesso che simuli un contesto industriale / CPS (Cyber Physical System) e configurato con un approccio zero trust tramite micro segmentation.

Il tool in questa repository zclod/dhall-microsegmentation ti permette di generare i file di configurazione per una rete nebula slackhq/nebula: 

Nebula: A scalable overlay networking tool with a focus on performance, simplicity and security (github.com) che si tratta di una sorta di vpn con il quale puoi implementare la micro segmentazione.

Se riesci a trovare delle immagini/container di macchine virtuali che ti rappresentano device iot/cps potresti cercare di connetterli tramite questo modo, implementare la microsegmentazione per isolarli tra di loro e testare che tutto funzioni.

## Concetti
- Cyber Physical System
- Zero Trust
- Micro-segmentation
- Nebula : https://github.com/slackhq/nebula
  - file configurazione: https://github.com/zclod/dhall-microsegmentation (not used btw)

## Setup
Install docker then:
```bash:
docker network create --driver=bridge   --subnet=172.20.0.0/24 iot-simulator
```
The network used on *bare-metal*:
- 127.20.0.100 (lighthouse)
- 127.20.0.2 (iot-dev-2)
- 127.20.0.3 (iot-dev-3)
- 127.20.0.4 (iot-dev-4)
- 127.20.0.50 (iot-master)

The address configured in micro-segmented-vpn:
- 192.168.100.1 (lighthouse)
- 192.168.100.2 (iot-dev-2)
- 192.168.100.3 (iot-dev-3)
- 192.168.100.4 (iot-dev-4)
- 192.168.100.50 (iot-master)

## How to use
First of use this script to build properly all containers:
```bash:
./build_containers.sh
```
Then start them with that script (or manually if you want)
```bash:
./start_containers.sh
```
Finally to inspect that everythin is working:
```bash:
docker attach iot-master
```
or:
```bash:
docker exec -it lighthouse /bin/bash
ping 192.168.100.*x*
```
where instead of ``lighthouse`` you can change with ``iot-master`` or ``iot-dev-*``.

## Troubleshooting
### TUN/TAP:
i've had some problem with TUN/TAP dev since i was runningh this entire project on Arch linux, but with 
```
find /lib/modules/ -iname 'tun.ko.zst'
```
And then after finding it:
```
insmod /lib/modules/6.2.11-arch1-1/kernel/drivers/net/tun.ko.zst
```
in the end with
```
docker run
  [...]
    --device /dev/net/tun:/dev/net/tun\
  [...]
```