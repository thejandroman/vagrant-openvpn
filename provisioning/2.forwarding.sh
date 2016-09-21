#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward
/bin/sed -ie 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
/sbin/sysctl -p
