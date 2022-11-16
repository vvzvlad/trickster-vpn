#!/bin/bash
apt update
apt install wireguard iptables ipcalc qrencode curl jq -y
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

cp ./sample_wg_cfg/wg-internal.conf /etc/wireguard/wg-internal.conf
wg-quick up wg-internal
systemctl enable wg-quick@wg-internal.service
systemctl daemon-reload

cp ./update_ru_routes.sh /root/update_ru_routes.sh

crontab -l > crontab.tmp
echo "@reboot sleep 30 && bash /root/update_ru_routes.sh > /root/update_routes_log.txt 2>&1" >> crontab.tmp
echo "0 3 * * mon bash /root/update_ru_routes.sh > /root/update_routes_log.txt 2>&1" >> crontab.tmp
crontab crontab.tmp
rm crontab.tmp
