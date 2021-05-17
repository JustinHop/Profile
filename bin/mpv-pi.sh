#!/bin/bash

set -euo pipefail
IFS='\t\n'

#set -x

SOCKET=/run/user/1000/mpv.socket

#env

case $1 in
    add)
        xclip -o | grep -P '^https?://' | sed \
            -e 's!https://www\.youtu\.be\.com!https://www.youtube.com!' \
            -e 's!https://www\.youtu\.be/!https://www.youtube.com/watch?v=!' \
            -e 's!https://youtu\.be/!https://www.youtube.com/watch?v=!' \
            -e 's!https://youtube\.com!https://www.youtube.com!' \
            -e 's!https://m\.youtube\.com!https://www.youtube.com!' | \
            xargs -tr -n1 -I{} echo loadfile {} append-play | ssh pi2 socat - /run/user/1000/mpv.socket
        ;;
    add_next)
        xclip -o | grep -P '^(https?:/)?/' | sed \
            -e 's!https://www\.youtu\.be\.com!https://www.youtube.com!' \
            -e 's!https://www\.youtu\.be/!https://www.youtube.com/watch?v=!' \
            -e 's!https://youtu\.be/!https://www.youtube.com/watch?v=!' \
            -e 's!https://youtube\.com!https://www.youtube.com!' \
            -e 's!https://m\.youtube\.com!https://www.youtube.com!' | \
            xargs -tr -n1 -I{} echo script-message-to info play_next {} | ssh pi3 socat - /run/user/1000/mpv.socket
        ;;
    next)
        echo "playlist_next" | ssh pi2 socat - /run/user/1000/mpv.socket
        ;;
    play)
        echo "cycle pause" | ssh pi2 socat - /run/user/1000/mpv.socket
        ;;
    prev)
        echo "playlist_prev" | ssh pi2 socat - /run/user/1000/mpv.socket
        ;;
    status)
        echo "script-binding info/show_info" | ssh pi2 socat - /run/user/1000/mpv.socket
        ;;
    stop)
        echo "cycle pause" | ssh pi2 socat - /run/user/1000/mpv.socket
        ;;
    toggle)
        echo "cycle pause" | ssh pi2 socat - /run/user/1000/mpv.socket
        ;;
    voldown)
        echo "add volume -5" | ssh pi2 socat - /run/user/1000/mpv.socket
        ;;
    volup)
        echo "add volume 5" | ssh pi2 socat - /run/user/1000/mpv.socket
        ;;
    *)
        ;;
esac


