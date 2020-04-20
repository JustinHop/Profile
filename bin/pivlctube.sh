#!/bin/bash

set -euo pipefail
IFS=$'\t\n'

set -x

unset DISPLAY

RUNCAST=~/src/youtube-subs2recentplaylist/run.sh
TUBE=~/tube/latest.m3u

if [ -x $RUNCAST  ]; then
    $RUNCAST #|| true
fi

# sleep 5s

eval exec vlc \
    -I ncurses \
    --extraintf http:telnet \
    --http-host 0.0.0.0 --http-port 8888 --http-password "12345678" \
    --telnet-host 0.0.0.0 --telnet-port 8823 --telnet-password "12345678" \
    --log-verbose 2 --syslog --syslog-ident vlc --syslog-facility user \
    --one-instance \
    --dbus \
    ${*:-$TUBE}
