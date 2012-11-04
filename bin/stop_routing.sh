#!/bin/sh
sudo iptables -t nat --flush
sudo iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
sudo iptables --append FORWARD --in-interface eth1 -j ACCEPT
