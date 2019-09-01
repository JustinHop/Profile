#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

set -x

video=""
declare -a time
time+=('00:00:00')


while read LINE ; do
    if echo $LINE | grep -siP '^\S+\.(mp4|mpg|avi|flv|wmv|mkv|mov)\s+\d\d:\d\d:\d\d$' ; then
        echo regex passed
        if ! [ "$video" ]; then
            video=$(echo $LINE | awk '{ print $1 }')
            if ! [ -f "$video" ]; then
                echo NOT A FILE
                #exit
            fi
        fi
        time+="$(echo $LINE | awk '{ print $2 }')"
        echo $time
    fi
done

echo "${#time[@]}"

for T in ${#time[@]}; do
    echo $T ${time[$T]}
done

