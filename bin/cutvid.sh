#!/bin/zsh
set -euo pipefail
IFS=$'\n\t'

SAFE=""
SAFE=echo

#set -x

# 2019-06-29 21:13 - vidcutter.libs.videoservice - INFO - /usr/bin/ionice -c 3 /usr/bin/ffmpeg -v error -ss 00:05:56.356 -t 00:21:16.043 -i "/mnt/auto/3/share/Video/P/POV.Punx.9.Super.Star.Edition.XXX.1080P.mp4" -c copy -avoid_negative_ts 1 -y "/mnt/auto/3/share/Video/P/POV.Punx.9.Super.Star.Edition.XXX.1080P_EDIT_00.mp4"


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
