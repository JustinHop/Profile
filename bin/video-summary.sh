#!/bin/zsh

set -euo pipefail
IFS=$'\n\t'

#set -x

HUMAN=""
ALIGN="cat"
TITLE=""

while getopts "aht" opt; do
  case ${opt} in
    a ) ALIGN="align"
      ;;
    h ) HUMAN=1
      ;;
    t ) TITLE="NAME FILESIZE GENERAL_BITRATE VIDEO_BITRATE AUDIO_BITRATE GEOMETRY\n"
      ;;
    * ) echo "$0 [-a](align) [-h](human) [-t](title) <FILE>..."
        exit 1
      ;;
  esac
done
shift $((OPTIND -1))

echo -ne "$TITLE"

for VIDEO in $@ ; do
  if [ -f "$VIDEO" ]; then
    A=$(echo $(mediainfo --Inform='Audio;%BitRate%' "$VIDEO") $(mediainfo --Inform='Audio;%FromStats_BitRate%' "$VIDEO") 0 | awk '{ print $1 }')
    G=$(echo $(mediainfo --Inform='General;%BitRate%' "$VIDEO") $(mediainfo --Inform='General;%OverallBitRate%' "$VIDEO") 0 | awk '{ print $1 }')
    H="$(mediainfo --Inform='Video;%Height%' $VIDEO)"
    S=$(stat -c '%s' "$VIDEO")
    V=$(echo $(mediainfo --Inform='Video;%BitRate%' "$VIDEO") $(mediainfo --Inform='Video;%FromStats_BitRate%' "$VIDEO") 0 | awk '{ print $1 }')
    W="$(mediainfo --Inform='Video;%Width%' $VIDEO)"
    if [ -n "$HUMAN" ]; then
      A=$(echo $A | numfmt --to=iec 2>/dev/null || echo 0)
      G=$(echo $G | numfmt --to=iec 2>/dev/null || echo 0)
      S=$(echo $S | numfmt --to=iec 2>/dev/null || echo 0)
      V=$(echo $V | numfmt --to=iec 2>/dev/null || echo 0)
    fi
    echo "$VIDEO $S $G $V $A ${W}x${H}"
  fi
done | $ALIGN
