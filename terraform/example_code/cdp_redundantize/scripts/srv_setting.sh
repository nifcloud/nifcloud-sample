#!/bin/bash

# Check rsync
if ! command -v rsync &> /dev/null
then
    dnf install -y rsync
fi

nmcli connection modify ens224 connection.autoconnect yes
nmcli connection modify ens224 ipv4.method manual ipv4.addresses ${private_address}
nmcli con reload
nmcli con down ens224 
nmcli con up ens224
