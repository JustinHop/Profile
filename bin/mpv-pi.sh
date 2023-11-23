#!/bin/bash

set -euo pipefail
IFS=$'\t\n'

#set -x

SOCKET="/run/user/1000/mpv.socket"

#env

case $1 in
    add)
        xclip -o | grep -P '^https?://' | sed \
            -e 's!https://www\.youtu\.be\.com!https://www.youtube.com!' \
            -e 's!https://www\.youtu\.be/!https://www.youtube.com/watch?v=!' \
            -e 's!https://youtu\.be/!https://www.youtube.com/watch?v=!' \
            -e 's!https://youtube\.com!https://www.youtube.com!' \
            -e 's!https://m\.youtube\.com!https://www.youtube.com!' | \
            xargs -tr -n1 -I{} echo loadfile {} append-play | ssh pi3 socat - $SOCKET
        ;;
    add_next)
        xclip -o | grep -P '^(https?:/)?/' | sed \
            -e 's!https://www\.youtu\.be\.com!https://www.youtube.com!' \
            -e 's!https://www\.youtu\.be/!https://www.youtube.com/watch?v=!' \
            -e 's!https://youtu\.be/!https://www.youtube.com/watch?v=!' \
            -e 's!https://youtube\.com!https://www.youtube.com!' \
            -e 's!https://m\.youtube\.com!https://www.youtube.com!' | \
            xargs -tr -n1 -I{} echo script-message-to info play_next {} | ssh pi3 socat - $SOCKET
        ;;
    next)
        echo "playlist_next" | ssh pi3 socat - $SOCKET
        ;;
    play)
        echo "cycle pause" | ssh pi3 socat - $SOCKET
        ;;
    prev)
        echo "playlist_prev" | ssh pi3 socat - $SOCKET
        ;;
    status)
        echo "script-binding info/show_info" | ssh pi3 socat - $SOCKET
        ;;
    stop)
        echo "cycle pause" | ssh pi3 socat - $SOCKET
        ;;
    toggle)
        echo "cycle pause" | ssh pi3 socat - $SOCKET
        ;;
    voldown)
        echo "add volume -5" | ssh pi3 socat - $SOCKET
        ;;
    volup)
        echo "add volume 5" | ssh pi3 socat - $SOCKET
        ;;
    *)
        ;;
esac


