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


