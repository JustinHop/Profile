#!/bin/bash

#export LIBVA_DRIVER_NAME=vdpau
#export VDPAU_DRIVER=nvidia

{ sleep 2s; xdotool type ff ; } &
~/bin/100next.sh 500 |rl | xargs mpv  --profile=x $*

clear
