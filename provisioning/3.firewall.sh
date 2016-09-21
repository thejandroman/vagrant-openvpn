#!/bin/bash

/usr/sbin/ufw allow OpenSSH
/usr/sbin/ufw allow 443/tcp
/usr/sbin/ufw allow from 10.8.0.0/24
/bin/sed -ie 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw

/bin/grep -q '^# START OPENVPN RULES$' /etc/ufw/before.rules \
    || /bin/sed -i "1i# START OPENVPN RULES\n# NAT table rules\n*nat\n:POSTROUTING ACCEPT [0:0]\n# Allow traffic from OpenVPN client to eth0\n-A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE\nCOMMIT\n# END OPENVPN RULES\n" /etc/ufw/before.rules

/usr/sbin/ufw disable
/usr/sbin/ufw --force enable
