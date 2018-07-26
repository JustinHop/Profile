#!/bin/sh

BRIGHT=${1:-1}
LINE=""

for DIS in $(xrandr | grep -P ' connected' | awk '{ print $1 }') ; do
    LINE=" $LINE --output $DIS --brightness $BRIGHT "
done

xrandr $LINE
