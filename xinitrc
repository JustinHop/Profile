#!/bin/bash

set -x

echo RUNNING $0 $1

XINIT_FILE="$HOME/Profile/xinitrc-$(hostname -s)"
if [ "$XDG_SESSION_DESKTOP" ]; then
    case "$XDG_SESSION_DESKTOP" in
        "systemd")
                exec systemd --user
                ;;
        "awesome")
                exec awesome
                ;;
        "xsession")
                if [ -f "$XINIT_FILE" ] ; then
                    exec "$XINIT_FILE"
                else
                    echo "The file $XINIT_FILE does not exist"
                    exec xterm
                fi
                ;;
        *)
            $1  || xterm
            ;;
    esac
else
    if [ -f "$XINIT_FILE" ] ; then
        exec "$XINIT_FILE"
    else
        echo "The file $XINIT_FILE does not exist"
        exec xterm
    fi
fi
