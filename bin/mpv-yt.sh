#!/bin/bash
IFS=$'\t\n'

set -x

ARG=""

export LIBVA_DRIVER_NAME=nvidia
export VDPAU_DRIVER=nvidia

SDIR="/home/justin/.config/mpv"
PL="$SDIR/mpv-playlistmanager/playlistmanager.lua:$SDIR/mpv-playlistmanager/titleresolver.lua"
APP="$SDIR/mpv-scripts/appendURL.lua"
YTDL="$SDIR/blue-sky-r/scripts/ytdl_hook_mask.lua"
YTQ="$SDIR/mpv-youtube-quality/youtube-quality.lua"
RE="$SDIR/mpv-reload/reload.lua"

MPV_SCRIPTS="${PL}:${YTDL}:${YTQ}:${RE}"

if [ -z $1 ]; then
    #ARG=$(cat $(find ~/tube -name '15*playlist.m3u' | sort | tail -n 1) | grep -vP '^#' | awk '!seen[$0]++' | xargs -I{} echo -n \"{}\"\  )
    ARG=$(find ~/tube -name '15*playlist.m3u' | sort | tail -n 1)
fi

IFS=$' ' read -r -a ARRAY <<< ${ARG}

eval exec -a youtube-player mpv \
    --keep-open=yes \
    --input-ipc-server=/tmp/mpvsocket \
    --msg-level=all=info \
    --msg-module \
    --hwdec=nvdec-copy \
    --audio-device='pulse/bluez_sink.30_21_C6_A8_94_2E.a2dp_sink' \
    --term-osd-bar \
    --scripts="$MPV_SCRIPTS" \
    "$@" $ARG
