#!/bin/bash
set -x
#{ sleep 2s ; xdotool type f ;xdotool type f ; } &
vidmanage show a a a b b c |shuf | head -n 500 | xargs mpv  $@
clear
