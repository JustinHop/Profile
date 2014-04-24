#!/bin/bash

if [ -f "$HOME/Profile/xinitrc-$HOSTNAME" ] ; then
    exec "$HOME/Profile/xinitrc-$HOSTNAME"
else
    exec xterm
fi
