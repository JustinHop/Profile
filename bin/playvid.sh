#!/bin/bash

#export LIBVA_DRIVER_NAME=vdpau
#export VDPAU_DRIVER=nvidia

~/bin/100next.sh 500 |rl | xargs mpv  --profile=x $*

clear
