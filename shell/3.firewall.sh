#!/bin/bash

ufw allow ssh
ufw allow 1194/udp
sed -ie 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw

grep -q '^# START OPENVPN RULES$' /etc/ufw/before.rules \
    || sed -i "1i# START OPENVPN RULES\n# NAT table rules\n*nat\n:POSTROUTING ACCEPT [0:0]\n# Allow traffic from OpenVPN client to eth0\n\n-A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE\nCOMMIT\n# END OPENVPN RULES\n" /etc/ufw/before.rules

ufw --force enable
