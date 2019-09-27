#!/bin/bash
set -euo pipefail
set -x

DRYRUN="echo"
while getopts "r" option; do
    case "${option}"
        in
        r)  DRYRUN=""
        ;;
    esac
done

ENC=/mnt/auto/1/share/Video/encode.sh

for FILE in $(vidmanage show a b c | xargs du -s | sort --human-numeric-sort | tac | head -n 100 | awk '{ print $2 }' ) ; do
    DIR="$(dirname $FILE)"
    BASENAME="$(basename $FILE)"
    if ffprobe -hide_banner $FILE 2>&1 | grep JHOP ; then
        echo $FILE already handled
    else
        cd "$DIR"
        $DRYRUN $ENC -r 0.75 "$BASENAME"
    fi
done

