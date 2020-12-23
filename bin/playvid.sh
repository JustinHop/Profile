#!/bin/bash
set -x
#{ sleep 2s ; xdotool type ff ; } &
vidmanage show a a a b b c |rl -c 500 | xargs mpv  --profile=x $@
clear
