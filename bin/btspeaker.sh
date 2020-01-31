#!/bin/bash

while sleep 1m; do
    if hcitool con | grep "54:B7:E5:41:AF:58" ; then
        ffplay -hide_banner -f lavfi -i "sine=frequency=250:duration=5" -autoexit -nodisp -volume 1
    fi
done
