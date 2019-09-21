#!/bin/bash
set -x

SAFE="echo"

if [ $1 ]; then
    SAFE=""
fi

DELETES=$(vidmanage show delete | wc -l)

if (( $DELETES > 0 )) ; then
    echo $DELETES Deletes
    echo 'vidmanage show deletes | xargs du -chs'
    echo 'vidmanage show deletes | xargs rm -v'
    exit 1
fi

cd /mnt/auto/1/share/Video

cd new
$SAFE namenorm *

if [ -z "$(ls -A /mnt/auto/1/share/Video/new)" ]; then
    echo ALREADY DONE
else
    for FILE in * ; do
        LETTER=$(echo ${FILE:0:1} | tr '[a-z]' '[A-Z]')
        LETTER2=$(echo ${FILE:1:1} | tr '[a-z]' '[A-Z]')
        if [ -d ../$LETTER ]; then
            ls -lsh $FILE
            if [ -d ../$LETTER/$LETTER2 ]; then
                if [ -f ../$LETTER/$LETTER2/$FILE ]; then
                    $SAFE rm -v $FILE
                fi
                $SAFE nice ionice -c 3 mv -vi $FILE ../$LETTER/$LETTER2
            else
                if [ -f ../$LETTER/$FILE ]; then
                    $SAFE rm -v $FILE
                fi
                $SAFE nice ionice -c 3 mv -vi $FILE ../$LETTER/
            fi
        fi
    done
fi
cd ..

$SAFE vidmanage update
vidmanage lists
df -h /mnt/auto/*
