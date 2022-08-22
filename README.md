# Trickster VPN
Trickster VPN is a configuration for WG that allows you to route local (internal to Russia) routes through a local (in-country) server and all other routes through a foreign server. 

You will need two servers: one inside the country (called internal) and one outside the country (called external).
For a test installation:
- clone the repository
- change in sample_wg_cfg/wg-external.conf and sample_wg_cfg/wg-mobile-client.conf in peer-Endpoint section internal server IP address
- run bootstrap scripts: bootstrap_external.sh for the external server, bootstrap_internal.sh for internal, and bootstrap_mobile.sh to show the QR code to connect from a mobile device. 

Note that bootstrap scripts use configs with preset encryption keys, which in this case will be the same for all installations: do not use configs with non-default keys for anything except testing!

!!! For production use, generate the keys yourself !!!


#TODO
1) Generation of keys by script when running bootstrap script
2) Docker-image
3) Nix-configuration
