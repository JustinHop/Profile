#!/bin/bash

DIR="/mnt/auto/1/share/Video"

find "$DIR" -type f -name '*vcp' | while read VIDEO ; do
    BASE="${VIDEO%%.vcp}"
    for VVV in ${BASE}* ; do
        echo $VVV
    done
done | grep -vP '\.vcp$' | xargs mpv --profile=x
