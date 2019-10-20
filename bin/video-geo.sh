#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

for FILE in $@ ; do
    WIDTH="$(mediainfo --Inform='Video;%Width%' $FILE)"
    HEIGHT="$(mediainfo --Inform='Video;%Height%' $FILE)"
    echo -e "$FILE\t$WIDTH\t$HEIGHT"
done
