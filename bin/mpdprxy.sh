#!/bin/bash
while true ; do
    ~/go/bin/mpdprxy --port 6600 \
        --hosts localhost:6602,localhost:6601 \
        --http 6610 &
    _PID=$!
    sleep 5s
    curl -v 'http://localhost:6610/?active%5B0%5D=1&default%5B0%5D=1'
    wait $_PID
    echo FAILED
    sleep 1s;
done
