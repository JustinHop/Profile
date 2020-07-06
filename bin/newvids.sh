#!/bin/zsh
set -euo pipefail
IFS=$'\n\t'

#set -x

TORRENT=/mnt/auto/1/share/torrent
NEW=/mnt/auto/1/share/Video/new
VIDEOS=""
SAFE=""
MINSIZE=100000

which namenorm > /dev/null
which vidmanage > /dev/null

if ! [ -d $NEW ] ; then
    echo FAIL
    exit
fi

if [ -z $* ]; then
    SAFE=echo
    echo dry run
fi

cd $TORRENT

du -chs $TORRENT

find /mnt/auto/1/share/torrent -type f -name abc.xyz.mp4 -exec echo $SAFE rm -v {} \;

fileloop () {
    for FILE in * ; do
        if echo "$FILE" | grep -vsqP '^_UNPACK' ; then
            FILENAME=$(echo $(basename "$FILE") | perl -pe 's/\.1\.mp4/.mp4/' | perl -pe 's/_?\.?mp4.*$/.mp4/i' )
            SIZE=$(du -s "$FILE" | tee /dev/stderr | awk '{ print $1 }')
            if [ "$SIZE" -gt "$MINSIZE" ]; then
                if [ -d "$FILE" ]; then
                    cd "$FILE"
                    find -type f -size +100M -exec $SAFE namenorm {} \;
                    cd -
                fi
                if (( $(find "$FILE" -type f -size +100M | wc -l) >= 2 )); then
                    FILENAME=""
                fi
                find "$FILE" -type f -size +100M -exec $SAFE mv -v -i {} $NEW/$FILENAME \;
                cd $NEW
                $SAFE namenorm "$FILENAME"
                cd -
            else
                $SAFE rm -rfv "$FILE"
            fi
        fi
    done
}

fileloop
fileloop

du -chs $TORRENT

$SAFE vidmanage update
vidmanage lists

df /mnt/auto/*
