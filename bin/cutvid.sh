#!/bin/zsh
set -euo pipefail
IFS=$'\n\t'

SAFE=""
SAFE=echo

#set -x

COPY="-c copy"
NORM='-vcodec copy -acodec aac -af \"aresample=async=1:first_pts=0\" -af dynaudnorm -metadata comment=\"Normalized_Audio ffmpeg dynaudnorm $(date)\" -fflags +genpts'

for CUTFILE in $@ ; do
    if echo $CUTFILE | grep -sqP '\.vcp$' ; then
        COUNT=0
        for TYPE in wmv mp4 mpg avi mkv ; do
            if [ -f "${CUTFILE%.vcp}.$TYPE" ]; then
                VIDEO="${CUTFILE%.vcp}.$TYPE"
                break
            fi
        done
        if [ -f "$VIDEO" ] && [ -f "$CUTFILE" ]; then
            IFS=$'\n'
            if ffprobe "$VIDEO" | grep -sq "Normalized" ; then
                OPTS="$COPY"
            else
                OPTS="$NORM"
            fi
            while read LINE ; do
                # echo $LINE foo
                TYPE="${VIDEO##*.}"
                TONE=$(echo $LINE | awk '{ print $1 }' | grep -oP '^\d+\.\d+')
                TTWO=$(echo $LINE | awk '{ print $2 }' | grep -oP '^\d+\.\d+')
                let "TDUR = $TTWO - $TONE"

                VIDEOOUT="${VIDEO%.*}_EDIT_$(printf '%02d' ${COUNT}).mkv"

                #echo nice ionice -c 3 ffmpeg -hide_banner -v info -ss $TONE -to $TTWO -i "$VIDEO" -c copy -avoid_negative_ts 1 -y "$VIDEOOUT"
                $SAFE nice ionice -c 3 ffmpeg -hide_banner -v info -ss \"$TONE\" -t \"$TDUR\" -i \"$VIDEO\" "$OPTS" -avoid_negative_ts 1 -y \"$VIDEOOUT\" || echo exited $!

                let "COUNT = $COUNT + 1"

            done < $CUTFILE
        fi
    fi
done
