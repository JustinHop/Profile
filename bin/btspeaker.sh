#!/bin/zsh

if [ $1 ]; then
    echo debug
    while sleep 30s; do
        date
        if hcitool con | grep -sq "54:B7:E5:41:AF:58" ; then
            ffplay -hide_banner -f lavfi -i "sine=frequency=250:duration=1" -autoexit -nodisp -volume 50 # >& /dev/null
        fi
    done
else
    while sleep 1m; do
        if hcitool con | grep -sq "54:B7:E5:41:AF:58" ; then
            ffplay -hide_banner -f lavfi -i "sine=frequency=25:duration=1" -autoexit -nodisp -volume 5  >& /dev/null
        fi
    done
fi
