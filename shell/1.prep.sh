#!/bin/bash

apt-get -qq update

if ! dpkg -s curl &> /dev/null; then
    apt-get -qq install curl
fi

if ! dpkg -s unattended-upgrades &> /dev/null; then
    apt-get -qq install unattended-upgrades
fi
