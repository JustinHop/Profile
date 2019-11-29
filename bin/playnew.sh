#!/bin/zsh
vidmanage lists

vidmanage show new | rl | xargs mpv --profile=x $*

clear
