#!/bin/zsh

if [ $1 ]; then
    echo debug
    while ffplay -hide_banner -f lavfi -i "sine=frequency=150:duration=10" -autoexit -nodisp -volume 60 ; do
        date
        sleep 10s
    done
else
    while ffplay -hide_banner -f lavfi -i "sine=frequency=75:duration=0.5" -autoexit -nodisp -volume 25 ; do
        sleep 180s
    done
fi
