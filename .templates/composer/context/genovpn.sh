#!/bin/bash

CLIENT_NAME=$1
echo $HOSTNAME
echo $CLIENT_NAME
echo $EASYRSA_PATH
echo $OVPN_CLIENTS_DIR
echo $SERVER_PORT
echo $PROTOCOL
echo $REMOTE_ADDR

PATH=$PATH:$EASYRSA_PATH

cd $EASYRSA_WORK_DIR
mkdir -p $OVPN_CLIENTS_DIR/$CLIENT_NAME
cd $EASYRSA_WORK_DIR
easyrsa gen-req  $CLIENT_NAME nopass batch
easyrsa sign-req client $CLIENT_NAME

cp $OVPN_CONFIG_DIR/ca.crt $OVPN_CLIENTS_DIR/$CLIENT_NAME/.
cp $OVPN_CONFIG_DIR/ta.key $OVPN_CLIENTS_DIR/$CLIENT_NAME/.
cp $EASYRSA_WORK_DIR/pki/private/$CLIENT_NAME.key $OVPN_CLIENTS_DIR/$CLIENT_NAME/.
cp $EASYRSA_WORK_DIR/pki/issued/$CLIENT_NAME.crt  $OVPN_CLIENTS_DIR/$CLIENT_NAME/.

OVPN=$CLIENT_NAME"-"$HOSTNAME.ovpn

cat << EOF > $OVPN_CLIENTS_DIR/$CLIENT_NAME/$OVPN
client
dev   tun
nobind
resolv-retry infinite
remote-cert-tls server
cipher AES-256-GCM
verb 3
script-security 3
key-direction 1
remote $HOST_URL $PUBLIC_PORT
proto $PROTOCOL

EOF

cd $OVPN_CLIENTS_DIR/$CLIENT_NAME

echo "<ca>"  >> $OVPN
cat ca.crt   >> $OVPN
echo "</ca>" >> $OVPN

echo "<cert>"        >> $OVPN
cat $CLIENT_NAME.crt >> $OVPN
echo "</cert>"       >> $OVPN

echo "<key>"         >> $OVPN
cat $CLIENT_NAME.key >> $OVPN
echo "</key>"        >> $OVPN

echo "<tls-auth>"  >> $OVPN
cat ta.key         >> $OVPN
echo "</tls-auth>" >> $OVPN

chown -R  $RUN_UID:$RUN_GID $OVPN_CLIENTS_DIR/$CLIENT_NAME

rm -f $CLIENT_NAME/ca.crt
rm -f $CLIENT_NAME/ta.key
rm -f $CLIENT_NAME/$CLIENT_NAME.key
rm -f $CLIENT_NAME/$CLIENT_NAME.crt
