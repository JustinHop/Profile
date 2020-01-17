#!/bin/bash

exec -a pidgin-player mpv --volume=75 --audio-device='pulse/alsa_output.pci-0000_00_1b.0.analog-stereo' --no-terminal $@
