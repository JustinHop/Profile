#!/bin/zsh
vidmanage lists

vidmanage show new | grep -Pv '\.m2ts'  | grep -Pv '~\d+~$' | rl |head -n 500 | shuf | xargs mpv  $*

clear
