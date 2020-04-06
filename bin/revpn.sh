#!/bin/bash

while sleep 30s ; do
    until ! sleep 30s && ip link show dev tun0 2>&1 > /dev/null ; do
        if [ -f ~/.config/revpn/enabled ]; then
            UUID=$(nmcli connection show | grep vpn | grep -P "(US1|VN1|TW1|TH1|SG1|PH1|MY1|MV1|MO1|KR1|JP1|HK1|ID1)" | awk '{ print $2 }' | sort -r | head -n 1)
            nmcli connection up $UUID
        fi
    done
done
