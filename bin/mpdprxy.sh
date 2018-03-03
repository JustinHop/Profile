#!/bin/bash
while true ; do
    ~/go/bin/mpdprxy --port 6600 \
        --hosts localhost:6602,localhost:6601 \
        --http 6610
    echo FAILED
    sleep 1s;
done
