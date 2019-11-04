#!/bin/bash


for i in $@; do
    EXTRA=""
    RES=$(ffprobe -hide_banner $i 2>&1 | grep Video | grep -oP '\d{3,4}x\d{3,4}')
    if $(echo $RES | grep -vsqP '(1920|1080|1280|720|540)') ; then
        EXTRA="BAD"
    fi
    echo -e "$i\t$RES\t$EXTRA"
done
