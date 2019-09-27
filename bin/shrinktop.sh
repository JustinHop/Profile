#!/bin/bash

DRYRUN="echo"
if [ $1 ]; then
    DRYRUN=""
fi

ENC=/mnt/auto/1/share/Video/encode.sh

for FILE in $(vidmanage a b c | xargs du -s | sort --human-numeric-sort | tac | head -n 100 ) ; do
    DIR="$(dirname $FILE)"
    BASENAME="$(basename $FILE)"
    if ffprobe $FILE | grep -sq ANEWRATE ; then
        echo $FILE already handled
    else
        cd "$DIR"
        $DRYRUN $ENC -r 0.75 "$BASENAME"
    fi
done

