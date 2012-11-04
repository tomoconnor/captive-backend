#/bin/sh

dhclient eth0

ifconfig eth1 172.16.254.1 netmask 255.255.255.0


