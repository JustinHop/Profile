#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

set -x

if [ "$*" ]; then
    echo $@ | xargs ssh pi /home/pi/Profile/bin/mpvappend
else
    FOO=$(xclip -o)
    if [ "$FOO" ]; then
        echo "$FOO" | xargs ssh pi /home/pi/Profile/bin/mpvappend
    fi
fi
