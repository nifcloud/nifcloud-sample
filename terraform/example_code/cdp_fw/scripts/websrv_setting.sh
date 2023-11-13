#!/bin/bash
nmcli connection modify ens224 connection.autoconnect yes
nmcli connection modify ens224 ipv4.method manual ipv4.addresses ${private_address}
nmcli con reload
nmcli con down ens224 
nmcli con up ens224
