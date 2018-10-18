Run a managed OpenVPN daemon in a container.

Managed means that your OpenVPN daemons will be monitored to make sure they stay up and running! If they crash, they will be restarted.

Mount a volume containing your `*.ovpn` files on /etc/openvpn (make it read-only for safety) and the startup script in this container will start a separate openvpn daemon for each `ovpn` file.

Run this container like this (substituting the directories and ports for your setup).
```
docker run --rm -d -v /home/user/openvpn:/etc/openvpn:ro -p 1194:1194/udp --cap-add=NET_ADMIN openvpn
```

# Notes About Security of OpenVPN in a container
`--cap-add=NET_ADMIN` is necessary for openvpn to be able to use `tun` devices with the Linux kernel. Be aware that this breaks some of the isolation of your docker container. Particularly on the network side... This is usually desired (we want our VPNs to be able to access the host's networks), but just be aware that this happens!
