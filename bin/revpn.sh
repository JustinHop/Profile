#!/bin/bash

# set -x

while true ; do
    if ! ip link show dev tun0 >/dev/null ; then
        if [ -f ~/.config/revpn/enabled ]; then
            UUID=$(nmcli connection show | grep vpn | grep -P "(US1|VN1|TW1|TH1|SG1|PH1|MY1|MV1|MO1|KR1|JP1|HK1|ID1)" | \
                grep -oP '([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}){1}' | \
                sort -R | head -n 1)
            nmcli connection up $UUID
        fi
    fi
    sleep 1m
done
