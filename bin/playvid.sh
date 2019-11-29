#!/bin/bash

#export LIBVA_DRIVER_NAME=vdpau
#export VDPAU_DRIVER=nvidia

~/bin/100next.sh |rl | xargs mpv  --profile=x --msg-level=all=info $*

clear
