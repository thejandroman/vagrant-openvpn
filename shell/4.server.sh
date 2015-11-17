#!/bin/bash

OPENVPN_DIR='/etc/openvpn'
SERVER_CONF="${OPENVPN_DIR}/server.conf"
RSA_DIR="${OPENVPN_DIR}/easy-rsa"

if ! dpkg -s openvpn &> /dev/null \
    && ! dpkg -s easy-rsa &> /dev/null
then
    apt-get -qq install openvpn easy-rsa
fi

gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > "${SERVER_CONF}"

sed -ie '
s/dh dh1024.pem/dh dh2048.pem/
s/;push "redirect-gateway def1 bypass-dhcp"/push "redirect-gateway def1 bypass-dhcp"/
s/;push "dhcp-option DNS 208.67.222.222"/push "dhcp-option DNS 208.67.222.222"/
s/;push "dhcp-option DNS 208.67.220.220"/push "dhcp-option DNS 208.67.220.220"/
s/;user nobody/user nobody/
s/;group nogroup/group nogroup/
' "${SERVER_CONF}"

cp -r /usr/share/easy-rsa/ "${OPENVPN_DIR}"
mkdir -p "${RSA_DIR}/keys"
sed -ie 's/KEY_NAME="EasyRSA"/KEY_NAME="server"/' "${RSA_DIR}/vars"

if [ ! -e "${OPENVPN_DIR}/dh2048.pem" ]
then
    time openssl dhparam -out "${OPENVPN_DIR}/dh2048.pem" 2048 2> /dev/null
fi

# Optionally set indentity information for certificates:
# export KEY_COUNTRY="<%COUNTRY%>" # 2-char country code
# export KEY_PROVINCE="<%PROVINCE%>" # 2-char state/province code
# export KEY_CITY="<%CITY%>" # City name
# export KEY_ORG="<%ORG%>" # Org/company name
# export KEY_EMAIL="<%EMAIL%>" # Email address
# export KEY_OU="<%ORG_UNIT%>" # Orgizational unit / department

if [ ! -e "${RSA_DIR}/keys/ca.crt" ] \
    || [ ! -e "${RSA_DIR}/keys/server.key" ] \
    || [ ! -e "${RSA_DIR}/keys/server.crt" ]
then
   cd "${RSA_DIR}" && source ./vars
   cd "${RSA_DIR}" && ./clean-all
fi

new_ca=false
if [ ! -e "${RSA_DIR}/keys/ca.crt" ]
then
    cd "${RSA_DIR}" && source ./vars
    cd "${RSA_DIR}" && ./build-ca --batch
    cp -f "${RSA_DIR}/keys/ca.crt" "${OPENVPN_DIR}"
    new_ca=true
fi

if $new_ca \
    || [ ! -e "${RSA_DIR}/keys/server.key" ] \
    || [ ! -e "${RSA_DIR}/keys/server.crt" ]
then
    cd $RSA_DIR && source ./vars
    cd "${RSA_DIR}" && ./build-key-server --batch server
    cp -f "${RSA_DIR}/keys/server.crt" "${OPENVPN_DIR}"
    cp -f "${RSA_DIR}/keys/server.key" "${OPENVPN_DIR}"
fi

service openvpn restart
