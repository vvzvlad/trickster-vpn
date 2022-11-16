#!/bin/bash

PRIVATE_KEY_EXTERNAL=`wg genkey`
PUBLIC_KEY_EXTERNAL=`echo $PRIVATE_KEY_EXTERNAL | wg pubkey`
PRIVATE_KEY_INTERNAL=`wg genkey`
PUBLIC_KEY_INTERNAL=`echo $PRIVATE_KEY_INTERNAL | wg pubkey`
PRIVATE_KEY_CLIENT_1=`wg genkey`
PUBLIC_KEY_CLIENT_1=`echo $PRIVATE_KEY_CLIENT_1 | wg pubkey`

INTERNAL_IP_ADDRESS=`dig +short txt ch whoami.cloudflare @1.0.0.1`

mkdir configs
cp ./wg-external.conf ./configs/wg-external.conf
cp ./wg-internal.conf ./configs/wg-internal.conf
cp ./wg-mobile-client.conf ./configs/wg-mobile-client.conf
cp ./update_include_routes.sh /etc/wireguard/update_include_routes.sh
touch /etc/wireguard/subnets_user_list.txt
touch /etc/wireguard/hosts_user_list.txt

echo "Generating keys..."
echo "********************************"
echo "Private key for External: $PRIVATE_KEY_EXTERNAL"
echo "Public key for External: $PUBLIC_KEY_EXTERNAL"
echo "Private key for Internal: $PRIVATE_KEY_INTERNAL"
echo "Public key for Internal: $PUBLIC_KEY_INTERNAL"
echo "Private key for Client 1: $PRIVATE_KEY_CLIENT_1"
echo "Public key for Client 1: $PUBLIC_KEY_CLIENT_1"
echo "********************************"


echo "Replacing templates in configs..."
sed -i "s^---PRIVATE_KEY_EXTERNAL---^$PRIVATE_KEY_EXTERNAL^" ./configs/wg-external.conf
sed -i "s^---PRIVATE_KEY_EXTERNAL---^$PRIVATE_KEY_EXTERNAL^" ./configs/wg-internal.conf
sed -i "s^---PRIVATE_KEY_EXTERNAL---^$PRIVATE_KEY_EXTERNAL^" ./configs/wg-mobile-client.conf

sed -i "s^---PUBLIC_KEY_EXTERNAL---^$PUBLIC_KEY_EXTERNAL^" ./configs/wg-external.conf
sed -i "s^---PUBLIC_KEY_EXTERNAL---^$PUBLIC_KEY_EXTERNAL^" ./configs/wg-internal.conf
sed -i "s^---PUBLIC_KEY_EXTERNAL---^$PUBLIC_KEY_EXTERNAL^" ./configs/wg-mobile-client.conf

sed -i "s^---PRIVATE_KEY_INTERNAL---^$PRIVATE_KEY_INTERNAL^" ./configs/wg-external.conf
sed -i "s^---PRIVATE_KEY_INTERNAL---^$PRIVATE_KEY_INTERNAL^" ./configs/wg-internal.conf
sed -i "s^---PRIVATE_KEY_INTERNAL---^$PRIVATE_KEY_INTERNAL^" ./configs/wg-mobile-client.conf

sed -i "s^---PUBLIC_KEY_INTERNAL---^$PUBLIC_KEY_INTERNAL^" ./configs/wg-external.conf
sed -i "s^---PUBLIC_KEY_INTERNAL---^$PUBLIC_KEY_INTERNAL^" ./configs/wg-internal.conf
sed -i "s^---PUBLIC_KEY_INTERNAL---^$PUBLIC_KEY_INTERNAL^" ./configs/wg-mobile-client.conf

sed -i "s^---PRIVATE_KEY_CLIENT_1---^$PRIVATE_KEY_CLIENT_1^" ./configs/wg-external.conf
sed -i "s^---PRIVATE_KEY_CLIENT_1---^$PRIVATE_KEY_CLIENT_1^" ./configs/wg-internal.conf
sed -i "s^---PRIVATE_KEY_CLIENT_1---^$PRIVATE_KEY_CLIENT_1^" ./configs/wg-mobile-client.conf

sed -i "s^---PUBLIC_KEY_CLIENT_1---^$PUBLIC_KEY_CLIENT_1^" ./configs/wg-external.conf
sed -i "s^---PUBLIC_KEY_CLIENT_1---^$PUBLIC_KEY_CLIENT_1^" ./configs/wg-internal.conf
sed -i "s^---PUBLIC_KEY_CLIENT_1---^$PUBLIC_KEY_CLIENT_1^" ./configs/wg-mobile-client.conf

sed -i "s^---INTERNAL_IP_ADDRESS---^$INTERNAL_IP_ADDRESS^" ./configs/wg-external.conf
sed -i "s^---INTERNAL_IP_ADDRESS---^$INTERNAL_IP_ADDRESS^" ./configs/wg-internal.conf
sed -i "s^---INTERNAL_IP_ADDRESS---^$INTERNAL_IP_ADDRESS^" ./configs/wg-mobile-client.conf

echo "Generating complete"
