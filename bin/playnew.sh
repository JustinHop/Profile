#!/bin/zsh
vidmanage lists

vidmanage show new | rl |head -n 500 | xargs mpv --profile=x $*

clear
