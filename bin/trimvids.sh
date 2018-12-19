#!/bin/zsh
#DEV="-i"
set -euo pipefail
IFS=$'\n\t'


if [ $1 ]; then
    SAFE=echo
fi
SAFE=echo

vidmanage lists
BEFORE=$(df -h | grep /mnt/auto | while read LINE ; do echo $(echo $LINE| awk 'NF{NF-=1};1'); done )

for M in 1 2 3 4 ; do
    if [ ! -d /mnt/auto/$M/share/Video ]; then
        echo no /mnt/auto/$M/share/Video 
        exit 1
    fi
done

vidmanage show delete | xargs du -chs

for V in $(vidmanage show delete) ; do
    if [ -f $V ]; then
        $SAFE rm -v $DEV $V
    fi
done

vidmanage update
vidmanage lists
echo $BEFORE | paste - <(df -h | awk '{$1=""}1' | grep /mnt/auto) | awk '{print $1" "$2"/"$6" "$3"/"$7" "$4"/"$8" "$5"/"$9" "$10}' | column -t

