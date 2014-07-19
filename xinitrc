#!/bin/bash

FILE="$HOME/Profile/xinitrc-$(hostname -s)"

if [ -f "$FILE" ] ; then
    exec "$FILE"
else
    echo "The file $FILE does not exist"
    exec xterm
fi
