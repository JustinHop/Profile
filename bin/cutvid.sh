#!/bin/zsh
set -euo pipefail
IFS=$'\n\t'

SAFE=""
SAFE=echo

#set -x


for CUTFILE in $@ ; do
    if echo $CUTFILE | grep -sqP '\.vcp$' ; then
        COUNT=0
        VIDEO=${CUTFILE%.vcp}.mp4
        if [ -f $VIDEO ] && [ -f $CUTFILE ]; then
            IFS=$'\n'
            while read LINE ; do
                # echo $LINE foo
                TONE=$(echo $LINE | awk '{ print $1 }' | grep -oP '^\d+\.\d+')
                TTWO=$(echo $LINE | awk '{ print $2 }' | grep -oP '^\d+\.\d+')
                let "TDUR = $TTWO - $TONE"

                VIDEOOUT=${VIDEO%.mp4}_EDIT_$(printf '%02d' ${COUNT}).mp4


                #echo nice ionice -c 3 ffmpeg -hide_banner -v info -ss $TONE -to $TTWO -i "$VIDEO" -c copy -avoid_negative_ts 1 -y "$VIDEOOUT"
                $SAFE nice ionice -c 3 ffmpeg -hide_banner -v info -ss "$TONE" -t "$TDUR" -i "$VIDEO" -c copy -avoid_negative_ts 1 -y "$VIDEOOUT" || echo exited $!

                let "COUNT = $COUNT + 1"

            done < $CUTFILE
        fi
    fi
done
