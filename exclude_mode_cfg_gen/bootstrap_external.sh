#!/bin/bash
apt update
apt install wireguard iptables ipcalc qrencode curl jq -y
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

cp ./sample_wg_cfg/wg-external.conf /etc/wireguard/wg-external.conf
wg-quick up wg-external
systemctl enable wg-quick@wg-external.service
systemctl daemon-reload
