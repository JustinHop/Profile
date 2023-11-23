#!/bin/zsh
set -euo pipefail
IFS=$'\n\t'

#set -x

TORRENT=/mnt/auto/1/share/torrent
TORRENT=/mnt/auto/2share2/sabnzbdplus/incoming
NEW=/mnt/auto/1/share/Video/new
NEW=/mnt/auto/2share2/Video/new
VIDEOS=""
SAFE=""
MINSIZE=100000

which namenorm > /dev/null
which vidmanage > /dev/null
which mediainfo > /dev/null

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

#find /mnt/auto/1/share/torrent -type f -name abc.xyz.mp4 -exec echo $SAFE rm -v {} \;

$SAFE sudo chown -R justin:justin $TORRENT
#$SAFE sudo chmod -R go+w $TORRENT

preloop() {
    cd $TORRENT
    $SAFE namenorm *(-/)
    #find $TORRENT -type f -name '*nzb' -exec $SAFE mv -v {} /mnt/auto/1/share/nzb/ \;
    find $TORRENT -type f -name '*jpg' -exec $SAFE rm -v {} \;
    for DDD in *(-/) ; do
        pushd "$DDD"
        find -type f -exec $SAFE chmod -x {} \;
        DDDD="$(echo $DDD | sed -e 's!/!_!g;s![\[\]]!!g')"
        for LINE in $(find . -type f -name 'abc.xyz*' -size +400M | grep -v UNPACK); do
            echo LINE=$LINE
            LINE=$(echo $LINE | perl -pe 's!^\./!!; ')
            CMD="mv -v --backup=numbered $LINE \"$DDDD-$LINE\""
            echo CMD=$CMD
            eval $SAFE $CMD
        done
        for MFILE in $(find -type f -size +400M | grep -vP '(\.r\d+|\.rar)$'); do
            if [ "$SAFE" ]; then
                mediainfo "$MFILE" > /dev/null && echo mediainfo ok "$MFILE" || $SAFE echo rm -rv "$MFILE"
            fi
        done
        popd
    done
}

fileloop () {
    for FILE in * ; do
        if echo "$FILE" | grep -vsqP 'UNPACK' ; then
            FILENAME=$(echo $(basename "$FILE") |  perl -pe 's/_?\.?mp4.*$/.mp4/i' )
            SIZE=$(du -s "$FILE" | tee /dev/stderr | awk '{ print $1 }')
            if [ "$SIZE" -gt "$MINSIZE" ]; then
                if [ -d "$FILE" ]; then
                    cd "$FILE"
                    find -type f -size +400M -exec $SAFE namenorm {} \;
                    cd -
                fi
                if (( $(find "$FILE" -type f -size +400M | wc -l) >= 2 )); then
                    FILENAME=""
                fi
                find "$FILE" -type f -size +400M -exec $SAFE mv -v --backup=numbered {} $NEW/$FILENAME \;
                cd $NEW
                $SAFE namenorm "$FILENAME"
                cd -
            else
                $SAFE rm -rfv "$FILE"
            fi
        fi
    done
}

preloop

fileloop
fileloop

du -chs $TORRENT

$SAFE vidmanage update
vidmanage lists

df /mnt/auto/*
