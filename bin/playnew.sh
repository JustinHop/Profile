#!/bin/zsh
vidmanage lists

vidmanage show new  | grep -Pv '~\d+~$' | rl |head -n 500 | xargs mpv --profile=x $*

clear
