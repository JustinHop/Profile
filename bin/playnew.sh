#!/bin/zsh
vidmanage lists

vidmanage show new | grep -Pv '\.m2ts'  | grep -Pv '~\d+~$' | shuf |head -n 500 | shuf | xargs mpv $*

clear
