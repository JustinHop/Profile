#!/bin/bash

~/bin/100next.sh | xargs mpv --audio-device='pulse/alsa_output.pci-0000_00_1b.0.analog-stereo' "$@"

clear
