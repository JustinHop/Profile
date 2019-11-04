#!/bin/zsh
vidmanage lists

vidmanage show new | rl | xargs mpv --audio-device='pulse/alsa_output.pci-0000_00_1b.0.analog-stereo' $@

clear
