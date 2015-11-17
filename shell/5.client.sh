#!/bin/bash -x

force=false
while getopts ":c:f" opt; do
    case $opt in
        c)
            CLIENTS=$OPTARG ;;
        f)
            force=true ;;
        \?)
            echo "Invalid argument: -${OPTARG}" >&2 &&
                exit 1 ;;
        :)
            echo "Option -${OPTARG} requires an argument." >&2 &&
                exit 1 ;;
    esac
done
shift $((OPTIND-1))

IPADDR=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
cd /etc/openvpn/easy-rsa && source ./vars

i=1
while [ $i -le $CLIENTS ]; do
    CLIENT="client${i}"
    i=$[$i+1]

    if $force || [ -e "/vagrant/client_certs/${CLIENT}.ovpn" ]; then
        echo "Skipped ${CLIENT} ovpn files."
        continue
    fi

    cd /etc/openvpn/easy-rsa && ./build-key --batch $CLIENT
    cp -f /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    sed -ie "s/my-server-1/$IPADDR/" /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    sed -ie 's/;user nobody/user nobody/' /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    sed -ie 's/;group nogroup/group nogroup/' /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    sed -ie 's/ca ca.crt//' /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    sed -ie 's/cert client.crt//' /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    sed -ie 's/key client.key//' /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    echo "<ca>" >> /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    cat /etc/openvpn/ca.crt >> /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    echo "</ca>" >> /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    echo "<cert>" >> /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    cat /etc/openvpn/easy-rsa/keys/$CLIENT.crt >> /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    echo "</cert>" >> /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    echo "<key>" >> /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    cat /etc/openvpn/easy-rsa/keys/$CLIENT.key >> /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn
    echo "</key>" >> /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn

    cp -f /etc/openvpn/easy-rsa/keys/$CLIENT.ovpn /vagrant/client_certs/
    cp -f /etc/openvpn/easy-rsa/keys/$CLIENT.crt /vagrant/client_certs/
    cp -f /etc/openvpn/easy-rsa/keys/$CLIENT.key /vagrant/client_certs/
    cp -f /etc/openvpn/easy-rsa/keys/ca.crt /vagrant/client_certs/

    echo "Created ${CLIENT} ovpn files."
done
