#!/bin/bash

set -euo pipefail
IFS='\t\n'

set -x
SSHFILE="/tmp/ssh-agent-env-$(whoami)"

if [[ -f  "$SSHFILE" ]]; then
    source "$SSHFILE"
fi

case $1 in
    add)
        xclip -o | grep -P '^https?://' | sed \
            -e 's!https://www\.youtu\.be\.com!https://www.youtube.com!' \
            -e 's!https://www\.youtu\.be/!https://www.youtube.com/watch?v=!' \
            -e 's!https://youtu\.be/!https://www.youtube.com/watch?v=!' \
            -e 's!https://youtube\.com!https://www.youtube.com!' \
            -e 's!https://m\.youtube\.com!https://www.youtube.com!' | \
            xargs -tr -n1 -I{} echo loadfile {} append-play | ssh pi socat - /tmp/mpv.socket
        ;;
    next)
        echo "playlist_next" | ssh pi socat - /tmp/mpv.socket
        ;;
    play)
        echo "cycle pause" | ssh pi socat - /tmp/mpv.socket
        ;;
    prev)
        echo "playlist_prev" | ssh pi socat - /tmp/mpv.socket
        ;;
    status)
        echo "script-binding info/show_info" | ssh pi socat - /tmp/mpv.socket
        ;;
    stop)
        echo "cycle pause" | ssh pi socat - /tmp/mpv.socket
        ;;
    toggle)
        echo "cycle pause" | ssh pi socat - /tmp/mpv.socket
        ;;
    voldown)
        echo "add volume -5" | ssh pi socat - /tmp/mpv.socket
        ;;
    volup)
        echo "add volume 5" | ssh pi socat - /tmp/mpv.socket
        ;;
    *)
        ;;
esac


