#!/bin/bash
nmcli connection modify ens192 connection.autoconnect yes
nmcli connection modify ens192 ipv4.method manual ipv4.addresses ${private_address}
nmcli connection modify ens192 ipv4.gateway ${private_gateway}
nmcli con reload
nmcli con down ens192 
nmcli con up ens192
