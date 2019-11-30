#!/bin/bash

set -euo pipefail
IFS=$'\t\n'

#set -x

DEBUG=""
VERBOSE=""
LS=""

while getopts "Dvl" opt; do
    case ${opt} in
        D ) DEBUG=1
            VERBOSE=1
            set -x
            ;;
        v ) VERBOSE=1
            ;;
        l ) LS=1
            ;;
        * ) echo "$0 [-D](DEBUG) [-v](verbose)"
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

VID_DIR=/mnt/auto/1/share/Video

function dbg(){
    if [ $VERBOSE ]; then
        echo $* > /dev/stderr
    fi
}

function rerips(){
    for RERIP in $(find -L $VID_DIR -type f -size +100M | grep -- '-nv-') ; do
        dbg "$RERIP"

        SHORT=$(echo "$RERIP" | grep -oP '^.*(?=[-\.](nv|copy|720|1080).*)')
        SHORT=$(echo "$SHORT" | perl -pe 's/\W(1080|720)[pP]//')
        dbg "$SHORT"

        LINES=""
        LINENUM=0

        if echo "$RERIP" | grep -sq EDIT ; then
            EDIT=$(echo "$RERIP" | grep -oP 'EDIT\S\d+')
            dbg "$EDIT"
            LINES=$(find -L $VID_DIR -type f -wholename "${SHORT}*" | grep $EDIT)
            dbg $LINES
        else
            LINES=$(find -L $VID_DIR -type f -wholename "${SHORT}*")
            dbg $LINES
        fi
        LINENUM=$(echo $LINES | xargs -n1 echo | wc -l )
        dbg $LINENUM

        if (( $LINENUM > 1 )); then
            echo $LINES
        fi

    done | xargs -n1 echo | sort -u
}


if [ "$LS" ]; then
    rerips | xargs ls -l
else
    rerips
fi
