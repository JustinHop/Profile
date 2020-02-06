#!/bin/zsh

while sleep 1m; do
    if hcitool con | grep -sq "54:B7:E5:41:AF:58" ; then
        ffplay -hide_banner -f lavfi -i "sine=frequency=25:duration=1" -autoexit -nodisp -volume 1 >& /dev/null
    fi
done
