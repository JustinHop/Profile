#!/bin/bash

[ "$1" ] || exit

TOHOST="$1"

echo $0:$TOHOST
$( scp ~/b $TOHOST: ; scp /usr/share/terminfo/r/rxvt-unicode-256color $TOHOST:/usr/share/terminfo/r ) | perl -pe "s/^/${TOHOST}:\t/g"
