#!/bin/bash
set -euo pipefail
set -x

SAFE="echo"

if (( $# == 1  )); then
    if [ $1 == 1 ]; then
        SAFE=""
    fi
fi

DELETES=$(vidmanage show delete | wc -l)

if (( $DELETES > 0 )) ; then
    echo $DELETES Deletes
    echo 'vidmanage show deletes | xargs du -chs'
    echo 'vidmanage show deletes | xargs rm -v'
    exit 1
fi

BASE=/mnt/auto/1/share/Video
cd $BASE

cd new
$SAFE namenorm *

if [ -z "$(ls -A /mnt/auto/1/share/Video/new)" ]; then
    echo ALREADY DONE
else
    for LIST in a b c ; do
        for FULLPATH in $(vidmanage show $LIST) ; do
            if echo $FULLPATH | grep $BASE/new ; then
                if df -h -t ext4 | grep '100%' ; then
                    echo "Filesystem Full"
                    exit
                else
                    FILE=$(basename $FULLPATH)
                    LETTER=$(echo ${FILE:0:1} | tr '[a-z]' '[A-Z]')
                    LETTER2=$(echo ${FILE:1:1} | tr '[a-z]' '[A-Z]')
                    if [ -d ../$LETTER ]; then
                        ls -lsh $FILE
                        if [ -d ../$LETTER/$LETTER2 ]; then
                            if [ -f ../$LETTER/$LETTER2/$FILE ]; then
                                $SAFE rm -v $FILE
                            else
                                $SAFE nice ionice -c 3 mv -vi $FILE ../$LETTER/$LETTER2
                                $SAFE vidmanage add $LIST $BASE/$LETTER/$LETTER2/$FILE
                            fi
                        else
                            if [ -f ../$LETTER/$FILE ]; then
                                $SAFE rm -v $FILE
                            else
                                $SAFE nice ionice -c 3 mv -vi $FILE ../$LETTER/
                                $SAFE vidmanage add $LIST $BASE/$LETTER/$FILE
                            fi
                        fi
                    fi
                fi
            fi
        done
    done
fi
cd ..

$SAFE vidmanage update
vidmanage lists
df -h /mnt/auto/*
