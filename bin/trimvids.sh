#!/bin/zsh
DEV=""
set -euo pipefail
IFS=$'\n\t'

#set -x

SAFE="echo"
if [ $* ]; then
    SAFE=""
else
    echo dry run
fi

vidmanage update
vidmanage lists

DELETES=$(vidmanage show delete | wc -l)

if (( $DELETES == 0 )); then
    echo ALREADY DONE
    exit
fi

BEFORE=$(df -h | grep /mnt/auto | while read LINE ; do echo $(echo $LINE| awk 'NF{NF-=1};1'); done )

for M in 1 2 3 4 5 ; do
    if [ ! -d /mnt/auto/$M/share/Video ]; then
        echo no /mnt/auto/$M/share/Video 
        exit 1
    fi
done

vidmanage show delete | xargs -r du -chs

for V in $(vidmanage show delete) ; do
    if [ -n "$V" ] ; then
        if [ -f $V ]; then
            $SAFE rm -v $DEV $V
        fi
    fi
done

vidmanage update
vidmanage lists
echo $BEFORE | paste - <(df -h | awk '{$1=""}1' | grep /mnt/auto) | awk '{print $1" "$2" "$3"/"$7" "$4"/"$8" "$5"/"$9" "$10}' | sort -k 6| column -t 

