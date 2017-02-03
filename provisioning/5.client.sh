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

ipaddr() {
    URLS=( http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address \
           http://169.254.169.254/latest/meta-data/public-ipv4 )

    for i in "${URLS[@]}"; do
        status_code=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' "${i}")
        if [ "${status_code}" -ne '404' ]; then
            ip_addr=$(curl -s "${i}")
            break
        fi
    done

    echo "${ip_addr}"
}

IPADDR=$(ipaddr)
RSA_DIR='/root/openvpn-ca'
KEY_DIR="${RSA_DIR}/keys"
CLIENT_CONFIGS='/vagrant/client-configs'

prep_rsa() {
    cd "${RSA_DIR}" || exit
    # shellcheck disable=SC1091
    . ./vars
}

cp /vagrant/provisioning/client.conf /root/client_base.conf
/bin/sed -ie "s/my-server-1/${IPADDR}/" /root/client_base.conf

prep_rsa

mkdir -p $CLIENT_CONFIGS

i=1
while [ $i -le "${CLIENTS}" ]; do
    CLIENT="client${i}"
    i=$((i+1))

    if ! $force && [ -e "${CLIENT_CONFIGS}/${CLIENT}.ovpn" ]; then
        echo "Skipped ${CLIENT} ovpn files."
        continue
    fi

    ./build-key --batch "${CLIENT}"
    /bin/cat "/root/client_base.conf" \
             <(echo -e '<ca>') \
             "${KEY_DIR}/ca.crt" \
             <(echo -e '</ca>\n<cert>') \
             "${KEY_DIR}/${CLIENT}.crt" \
             <(echo -e '</cert>\n<key>') \
             "${KEY_DIR}/${CLIENT}.key" \
             <(echo -e '</key>\n<tls-auth>') \
             "${KEY_DIR}/ta.key" \
             <(echo -e '</tls-auth>') \
             > "${CLIENT_CONFIGS}/${CLIENT}.ovpn"

    echo "Created ${CLIENT} ovpn files."
done
