#!/bin/bash

FILE="$HOME/Profile/xinitrc-$(hostname -s)"

if [ -f "$FILE" ] ; then
    exec "$FILE"
else
    exec xterm
fi
