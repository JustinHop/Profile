#!/bin/bash
set -x

VIDS=""
RUNARGS=""

for ARG in $@; do
    if [ -f $ARG ]; then
        VIDS="$VIDS -v $ARG:/data/$(basename $ARG)"
    else
        RUNARGS="$RUNARGS $ARG"
    fi
done

docker run -it --rm \
    -v /dev/adsp:/dev/adsp \
    -v /dev/dri:/dev/dri \
    --device /dev/snd \
    -e "PULSE_SERVER=tcp:thinkpad1:4713" \
    -e "PULSE_COOKIE_DATA=$(pax11publish -d | grep --color=never -Po '(?<=^Cookie: ).*')" \
    -v /run/user/$UID/pulse:/run/user/0/pulse \
    -v /dev/dsp:/dev/dsp $VIDS \
    -v /home/justin/.config/mpv/mpv-docker.conf:/conf/mpv.conf \
    -v /home/justin/.config/mpv/input.conf:/conf/input.conf \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    --privileged \
    jwater7/mpv \
    mpv -v --config-dir=/conf $RUNARGS /data/
