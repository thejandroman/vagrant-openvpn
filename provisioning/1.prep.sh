#!/bin/bash

wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg|apt-key add -
echo "deb http://build.openvpn.net/debian/openvpn/stable xenial main" > /etc/apt/sources.list.d/openvpn-aptrepo.list

/usr/bin/apt-get -qq update

install_package() {
    if ! command -v "$1" > /dev/null 2>&1; then
        /usr/bin/apt-get -qq install "$1"
    fi
}

install_package "curl"
install_package "unattended-upgrades"
install_package "openvpn"
install_package "easy-rsa"
