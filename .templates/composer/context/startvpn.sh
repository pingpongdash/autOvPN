#!/bin/bash

if [ -e /etc/openvpn/server/server.conf ]; then
    echo "server.conf already exists."
else
    chown -R  $RUN_UID:$RUN_GID /etc/openvpn
    su - $RUN_UID

    PATH=$PATH:$EASYRSA_PATH

    echo "set_var EASYRSA_BATCH \"1\"" >> vars
    echo "set_var EASYRSA_REQ_CN \"$SERVER_CN\"" >> vars

    mkdir $EASYRSA_WORK_DIR
    cd $EASYRSA_WORK_DIR
    mv $OVPN_CONFIG_DIR/vars .
    easyrsa  init-pki
    easyrsa --batch build-ca nopass
    easyrsa  gen-req  $HOSTNAME nopass batch
    easyrsa  sign-req server $HOSTNAME

    cd $OVPN_CONFIG_DIR
    cp $EASYRSA_WORK_DIR/pki/ca.crt                 .
    cp $EASYRSA_WORK_DIR/pki/private/$HOSTNAME.key .
    cp $EASYRSA_WORK_DIR/pki/issued/$HOSTNAME.crt  .

    openssl dhparam -out    dh.pem 2048
    openvpn --genkey secret ta.key

    cd $OVPN_CONFIG_DIR
    cat << EOF > server.conf
user  nobody
group nobody
dev  tun
cipher AES-256-GCM
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "redirect-gateway def1 bypass-dhcp"
keepalive 10 120
persist-key
persist-tun
ifconfig-pool-persist ipp.txt
explicit-exit-notify 1
tun-mtu 1500
mssfix 1460
client-to-client
verb 3
status /var/log/openvpn-status.log
log    /var/log/openvpn.log
EOF
    echo "port $VPN_PORT"    >> server.conf
    echo "proto $PROTOCOL"   >> server.conf
    echo "server $VPN_SERVER_ADDR $VPN_SERVER_NETMASK" >> server.conf

    echo "ca       $OVPN_CONFIG_DIR/ca.crt"        >> server.conf
    echo "tls-auth $OVPN_CONFIG_DIR/ta.key  0"     >> server.conf
    echo "dh       $OVPN_CONFIG_DIR/dh.pem"        >> server.conf
    echo "key      $OVPN_CONFIG_DIR/$HOSTNAME.key" >> server.conf
    echo "cert     $OVPN_CONFIG_DIR/$HOSTNAME.crt" >> server.conf
    chown -R  $RUN_UID:$RUN_GID /etc/openvpn
fi

if [ "$ALLOW_INTERNET_ACCESS" = "yes" ]; then
    iptables -t nat -A POSTROUTING -s ${VPN_SERVER_ADDR}/24 -o ${OVPN_NATDEVICE} -j MASQUERADE
fi

openvpn ${OVPN_CONFIG_DIR}/server.conf

/bin/bash

