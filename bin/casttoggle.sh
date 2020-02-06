#!/bin/bash


STATUS=$(catt status)
STATE=$(echo "$STATUS" | grep -P "^State:" | awk '{ print $2 }')

echo $STATE

if [ "$STATE" == "PLAYING" ]; then
    catt pause
elif [ "$STATE" == "PAUSED" ]; then
    catt play
fi
