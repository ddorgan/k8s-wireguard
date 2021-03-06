#!/bin/bash
umask 177
DATA_PATH="../data"
KUBERNETES_PATH="../kubernetes"
TEMPLATES_PATH="../kubernetes/templates"
SERVER_PRIVATE_KEYFILE="$DATA_PATH/server-privatekey"
SERVER_PUBLIC_KEYFILE="$DATA_PATH/server-publickey"
CLIENT_PRIVATE_KEYFILE="$DATA_PATH/client-privatekey"
CLIENT_PUBLIC_KEYFILE="$DATA_PATH/client-publickey"

wg genkey | tee $SERVER_PRIVATE_KEYFILE | wg pubkey > $SERVER_PUBLIC_KEYFILE
wg genkey | tee $CLIENT_PRIVATE_KEYFILE | wg pubkey > $CLIENT_PUBLIC_KEYFILE

SERVER_PRIVATE_KEY=$(cat $SERVER_PRIVATE_KEYFILE)
SERVER_PUBLIC_KEY=$(cat $SERVER_PUBLIC_KEYFILE)
CLIENT_PRIVATE_KEY=$(cat $CLIENT_PRIVATE_KEYFILE)
CLIENT_PUBLIC_KEY=$(cat $CLIENT_PUBLIC_KEYFILE)
SERVER_PUBLIC_IP=$(cat $DATA_PATH/workers | awk {'print $2'} | head -1)


cat $TEMPLATES_PATH/wireguard-configmap.yml | sed -e "s@SERVER_PRIVATE_KEY@$SERVER_PRIVATE_KEY@g" | sed -e "s@CLIENT_PUBLIC_KEY@$CLIENT_PUBLIC_KEY@g" > $KUBERNETES_PATH/wireguard-configmap.yml
cat $TEMPLATES_PATH/wireguard-client.conf | sed -e "s@CLIENT_PRIVATE_KEY@$CLIENT_PRIVATE_KEY@g" | sed -e "s@SERVER_PUBLIC_KEY@$SERVER_PUBLIC_KEY@g" | sed -e "s@SERVER_PUBLIC_IP@$SERVER_PUBLIC_IP@g" > $DATA_PATH/wireguard-client.conf
 

