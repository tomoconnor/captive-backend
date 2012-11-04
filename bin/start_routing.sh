#! /bin/sh
sudo iptables -t nat --flush
sudo iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
sudo iptables --append FORWARD --in-interface eth1 -j ACCEPT

sudo iptables -t nat -A PREROUTING -m state --state NEW,ESTABLISHED,RELATED,INVALID -p udp --dport 67 -j ACCEPT
sudo iptables -t nat -A PREROUTING -m state --state NEW,ESTABLISHED,RELATED,INVALID -p tcp --dport 67 -j ACCEPT
sudo iptables -t nat -A PREROUTING -m state --state NEW,ESTABLISHED,RELATED,INVALID -p udp --dport 53 -j ACCEPT
sudo iptables -t nat -A PREROUTING -m state --state NEW,ESTABLISHED,RELATED,INVALID -p tcp --dport 53 -j ACCEPT


sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to 172.16.254.1:4567
sudo iptables -t nat -A PREROUTING -p udp --dport 80 -j DNAT --to 172.16.254.1:4567

sudo iptables -t nat -N NET
sudo iptables -t nat -A NET -j ACCEPT

