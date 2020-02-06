#!/bin/bash

set -euo pipefail
IFS=$'\t\n'

# set -x


#https://invidio.us/watch?v=kZfKkc21-tI

#invidio.us

fixtoyoutube() {
    #echo $1 | tee /dev/stderr | sed -e 's/invidio.us/youtube.com/' -e 's/hooktube.com/youtube.com/' | tee /dev/stderr
    local URL=$(echo $1 | sed -e 's/invidio.us/youtube.com/' -e 's/hooktube.com/youtube.com/')
    notify-send --app-name=youtube CATT "attempting to cast $URL" &
    echo "$URL"
}

WAIT=""
if (( $# > 0 )); then
    for ARG in "$@" ; do
        fixtoyoutube "$ARG" | xargs -r catt add &
        sleep 1s
        WAIT=$!
        echo
    done
else
    for ARG in $(xclip -o) ; do
        fixtoyoutube "$ARG" | xargs -r catt add &
        sleep 1s
        WAIT=$!
        echo
    done
fi
if [ -n "$WAIT" ]; then
    wait $WAIT
fi
