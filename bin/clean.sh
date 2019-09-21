#!/bin/zsh
set -x

DRY=echo

if [ "$1" ]; then
    DRY=""
fi

for VCP in *.vcp ; do
    MP4=${VCP%.*}.mp4
    WMV=${VCP%.*}.wmv
    AVI=${VCP%.*}.avi

    if [ -f "$MP4" ]; then
        du -chs "$MP4" "$VCP"
        $DRY rm -v "$MP4" "$VCP"
    elif [ -f "$WMV" ]; then
        du -chs "$WMV" "$VCP"
        $DRY rm -v "$WMV" "$VCP"
    elif [ -f "$AVI" ]; then
        du -chs "$AVI" "$VCP"
        $DRY rm -v "$AVI" "$VCP"
    fi
done
