#!/bin/zsh

set -euo pipefail
IFS=$'\n\t'

#set -x

DRY="echo"

SAFE="echo"
if [ $* ]; then
    SAFE=""
else
    echo dry run
fi

$SAFE vidmanage update
$SAFE trimvids 1

COUNT=0

for LIST in a b c new ; do
    for VIDEO in $(vidmanage show $LIST) ; do
        echo $(( COUNT++ )) > /dev/null
        #if (( COUNT == 10 )); then
        #    exit
        #fi
        BASE=${VIDEO%.*}
        TYPE="${VIDEO##*.}"

        if [[ $TYPE == "mkv" ]] ; then
            echo Already Matroska
        else
            FORMAT=$(mediainfo --Inform='General;%Format%' "$VIDEO")
            if [[ $FORMAT == "Matroska" ]] ; then
                $SAFE mv -v "$VIDEO" "$BASE.mkv"
                $SAFE vidmanage add $LIST "$BASE.mkv"
            fi
        fi
    done
done

$SAFE vidmanage update
vidmanage lists
