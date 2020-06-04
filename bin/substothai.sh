#!/bin/bash

set -euo pipefail
IFS=$'\t\n'

#set -x

#set -- "${1:-$(</dev/stdin)}" "${@:2}"
#$read b < "${1:-/dev/stdin}"

catter(){
    cat | nl -ba
}

COUNT=1

while read LINE ; do
    #echo "$COUNT: $LINE"
    if echo "$LINE" | grep -sP '^(\d+|\d\d:\d\d:\d\d.*|\r?)\r?$' ; then
        true
    else
        until translate-cli --output_only --to th -- "$LINE" | tee /dev/stderr | grep -sPv '^(MYMEMORY WARNING)' ; do
            echo SLEEPING > /dev/stderr
            sleep 1h
        done
    fi
    let "COUNT++"
done < "${1:-/dev/stdin}"

#while read LINE < "${1:-/dev/stdin}" ; do
#    let "COUNT++"
#    echo "$COUNT:\t$LINE"
#done
