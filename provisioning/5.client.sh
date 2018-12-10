#!/bin/bash -x

force=false
while getopts ":c:p:f" opt; do
    case $opt in
        c)
            CLIENTS=$OPTARG ;;
        f)
            force=true ;;
        p)
            PROVIDER="${OPTARG}" ;;
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
           http://169.254.169.254/latest/meta-data/public-ipv4 \
           "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2017-08-01&format=text" )

    if  [ "$PROVIDER" = "azure" ]; then
        CURL_CODE_CMD="curl -H Metadata:true"
        CURL_CMD="curl -H Metadata:true"
    else
        CURL_CODE_CMD="curl --head"
        CURL_CMD="curl"
    fi

    for i in "${URLS[@]}"; do
        status_code=$($CURL_CODE_CMD -o /dev/null -s --write-out '%{http_code}\n' "${i}")
        if [ "${status_code}" -ne '404' ] && [ "${status_code}" -ne '400' ]; then
            ip_addr=$($CURL_CMD -s "${i}")
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
