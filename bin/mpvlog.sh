#!/bin/bash



tail -n 1000 -q -F ~/tmp/mpv.log 2>/dev/null |\
    grep --line-buffered -F '[cplayer] Playing:' |\
    while read I ; do
        echo
        echo
        echo
        echo
        echo

        MOV=$(find /media/twoterra/share/Torrent /media/twoterra/share/Video -type f -name $(basename $(echo $I | cut -d: -f2 ) ) )
        echo $MOV > ~/tmp/mpv.last
        ls -sh --color=always $MOV
        echo
        avprobe -of ini -pretty $MOV | sed 1,2d 
        if vidmanage -o 2>/dev/null | grep -s -q "$MOV" ; then
            echo ON A LIST
        elif vidmanage -O 2>/dev/null |  grep -s -q "$MOV" ; then
            echo ON KEEP LIST
        elif vidmanage -i 2>/dev/null |  grep -s -q "$MOV" ; then
            echo ON DELETE LIST
        else
            echo UNLISTED
        fi
done
