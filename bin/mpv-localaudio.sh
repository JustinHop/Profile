#!/bin/bash

exec mpv --volume=100 --audio-device='pulse/alsa_output.pci-0000_00_1b.0.analog-stereo' $@
