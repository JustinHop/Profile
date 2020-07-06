#!/bin/bash

set -euo pipefail
IFS=$'\t\n'

set -x

VER=1

POS=$(xmousepos | awk '{ print $1 }')

OUTPUT="eDP-1"

if (( $POS>3840 )) ; then
    OUTPUT="DP-2-1"
elif (( $POS>1920 )) ; then
    OUTPUT="DP-2-2"
fi

[ "$VER" ] && echo $OUTPUT > /dev/stderr

for DEVICE in $(xsetwacom --list devices | cut -d: -f2 | awk '{ print $1 }') ; do
    [ "$VER" ] && echo $DEVICE > /dev/stderr
    xsetwacom --set $DEVICE MapToOutput $OUTPUT &
done

