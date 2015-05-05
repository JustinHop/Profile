#!/bin/bash

TIME=300s

if [ $1 ]; then
    TIME="$1"
fi

while ~/Profile/bin/hipchatfortune.rb ; do
    sleep $TIME
done
