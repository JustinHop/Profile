#!/bin/bash




tail -n 1000 -q -F ~/tmp/mplayer.log 2>/dev/null |\
    grep --line-buffered 'Playing' |\
    while read I ; do
        echo
        echo
        echo
        echo
        echo

        MOV=$(echo $I | awk '{ print $2 }' | sed 's/\.$//')
        ls -sh --color=always $MOV
        echo
        avprobe -of ini -pretty $MOV | sed 1,2d 
        if vidmanage -o 2>/dev/null | grep -s -q "$MOV" ; then
            echo ON A LIST
        elif vidmanage -O 2>/dev/null |  grep -s -q "$MOV" ; then
            echo ON KEEP LIST
        else
            echo UNLISTED
        fi
done
