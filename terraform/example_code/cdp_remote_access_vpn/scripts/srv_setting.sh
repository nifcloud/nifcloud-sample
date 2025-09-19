#!/bin/bash
nmcli connection modify ${network_if} connection.autoconnect yes
nmcli connection modify ${network_if} ipv4.method manual ipv4.addresses ${private_address}
nmcli con reload
nmcli con down ${network_if}
nmcli con up ${network_if}
