#!/bin/bash
set -x

trap 'kill -9 $VNC_PID; exit 1' SIGTERM SIGINT SIGKILL

while true ; do
   x11vnc \
      -shared \
      -forever \
      -avahi \
      -rfbport 1930 \
      -passwdfile ~/vnc &
   VNC_PID=$!
   wait $VNC_PID
   sleep 10s
done
      #-noxdamage \
      #-xkb \
      #-ncache 10 \
      #-ncache_cr &
