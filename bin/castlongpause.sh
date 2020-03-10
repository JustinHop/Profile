#!/bin/bash

set -x

INTERVAL=90s
TIMEOUT=30
COUNT=0
TO="timeout --foreground $TIMEOUT"
while true ; do

    STATUS=$(until $TO catt status ; do sleep 30s ; done || true)
    STATE=$(echo "$STATUS" | grep -P "^State:" | awk '{ print $2 }')

    # echo $STATE

    if [ "$STATE" == "PLAYING" ]; then

        COUNT=0

    elif [ "$STATE" == "PAUSED" ]; then

        VOLUME=$(echo "$STATUS" | grep -P "^Volume:" | awk '{ print $2 }')

        $TO catt volume 0
        $TO catt play
        # sleep 2s
        $TO catt pause
        $TO catt volume $VOLUME

        if [ $COUNT == 10 ]; then
            $TO catt rewind 10
            COUNT=0
        fi
    fi

    sleep $INTERVAL

done
