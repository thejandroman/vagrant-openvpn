#!/bin/bash

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
