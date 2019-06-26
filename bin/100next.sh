#!/bin/bash

COUNT=${1:-100}
let "COUNTP=COUNT+1"

VIDLIST=/tmp/vidlist
TMP=${VIDLIST}.$$

if [ ! -f $VIDLIST ] || (( $RANDOM % 6 == 0 )); then
    echo REGENERATING LIST > /dev/stderr
    sleep 1
    vidmanage show a b c | rl | rl > $VIDLIST
fi

LINES=$(wc -l $VIDLIST | awk '{ print $1 }')

sed -n "$COUNTP,${LINES}p" < $VIDLIST > $TMP
head -n $COUNT $VIDLIST | tee -a $TMP
mv $TMP $VIDLIST
