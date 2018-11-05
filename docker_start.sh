#!/bin/sh
# Copyright 2018. Spotlight Cybersecurity LLC
# Released under an MIT license. See LICENSE file.
#
# Find all OpenVPN configs (*.ovpn) in /etc/openvpn and create a runit
# service file that will monitor the openvpn server processes and make sure
# they are running correctly (e.g. this will restart them if they crash).

# We use --cd to change into /etc/openvpn so that the ovpn files can use
# relative directory paths to find other files

find /etc/openvpn -name '*.ovpn' -type f -maxdepth 1 | {
	while read fn; do
		BN="`basename "$fn"`"
		echo "** creating runit script for openvpn config at $fn"
mkdir "/etc/service/openvpn_${BN}"
cat > "/etc/service/openvpn_${BN}/run" <<EOF
#!/bin/sh
exec openvpn --cd /etc/openvpn --config "$fn"
EOF
chmod ugo+rx "/etc/service/openvpn_${BN}/run"
	done;
}

if [[ "`ls -1 /etc/service | wc -l`" == "0" ]]; then echo "no configs? exiting..."; exit 1; fi

# openvpn initializations
# from https://github.com/kylemanna/docker-openvpn/blob/master/bin/ovpn_run
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
	mknod /dev/net/tun c 10 200
fi

exec /sbin/runsvdir -P /etc/service
