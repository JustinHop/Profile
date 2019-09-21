#!/bin/bash
#set -euo pipefail

set -x

DRYRUN=""
FFMPEG="nice ionice -c 3 ffmpeg -hide_banner -v info "

while getopts "n" option; do
    case "${option}"
        in
        n)  DRYRUN="echo"
        ;;
    esac
done

shift $((OPTIND-1))

for FILE in $@ ; do
    SOURCE="${FILE%.*}"
    EXT="${FILE##*.}"
    ffmpeg -i "$SOURCE.$EXT" 2>&1 | tee /dev/stderr \
        | grep Chapter \
        | perl -pe "s/.*Chapter #[0-9]+:([0-9]+): start ([0-9]+\.[0-9]+), end ([0-9]+\.[0-9]+)/-i \"$SOURCE.$EXT\" -vcodec copy -acodec copy -ss \2 -to \3 -avoid_negative_ts 1 -y \"$SOURCE-\1.$EXT\"/" \
        | xargs -n 14 $DRYRUN $FFMPEG
done

