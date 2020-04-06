#!/bin/bash

set -euo pipefail
IFS=$'\t\n'

# set -x

fixtoyoutube() {
    #echo $1 | tee /dev/stderr | sed -e 's/invidio.us/youtube.com/' -e 's/hooktube.com/youtube.com/' | tee /dev/stderr
    local URL=$(echo $1 | sed -e 's/invidio.us/youtube.com/' -e 's/hooktube.com/youtube.com/')
    for U in $(echo "$URL" | grep -oP 'https?:\S+'); do
        sleep 1s
        # notify-send --app-name=youtube CATT "attempting to cast $U" &
        echo "$U"
    done
}

dotheloop() {
    local SLEEP=$(( ( RANDOM % 5 )  + 1 ))
    for LINK in $(fixtoyoutube "$@"); do
        {   local COUNT=1
            until timeout 30 catt add "$LINK" ; do
                sleep ${SLEEP}s
                COUNT=$((COUNT+=1))
                if [ $COUNT == 3 ]; then
                    break
                fi
            done ; } &
        sleep ${SLEEP}s
        echo
    done
}

if (( $# > 0 )); then
    for ARG in "$@" ; do
        if [ -f "$ARG" ]; then
            for AR in $(cat "$ARG"); do
                dotheloop "$AR"
            done
        else
            dotheloop "$ARG"
        fi
    done
else
    for ARG in $(xclip -o) ; do
        dotheloop "$ARG"
    done
fi
