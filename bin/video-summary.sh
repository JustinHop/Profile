#!/bin/zsh

set -euo pipefail
IFS=$' \n\t'

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
    t ) TITLE="NAME FILESIZE GENERAL_BITRATE VIDEO_BITRATE AUDIO_BITRATE GEOMETRY VIDEO_CODEC AUDIO_CODEC\n"
      ;;
    * ) echo "$0 [-a](align) [-h](human) [-t](title) <FILE>..."
        exit 1
      ;;
  esac
done
shift $((OPTIND -1))

function process_video() {
  FILE="$1"
  local VIDEOINFO=$(mediainfo --Output=XML "$FILE" \
    | manyio -o json \
    | jq '.MediaInfo.media.track' \
    | grep -v '"@type' \
    | json2yaml \
    | grep -v '=$' \
    | sed -n '/^-.*Video/,/^-/p' \
    | grep -vP '^-' \
    | sed 's/: /=/' \
    | tr -d \' \
    | sed 's/=/="/' \
    | sed 's/$/"/' \
    | grep -v 'Audio_extra' \
    | sed 's/^\s\+/export Video_/')

  local AUDIOINFO=$(mediainfo --Output=XML "$FILE" \
    | manyio -o json \
    | jq '.MediaInfo.media.track' \
    | grep -v '"@type' \
    | json2yaml \
    | grep -v '="$' \
    | tee /dev/stderr \
    | sed -n '/^-.*Audio/,/$a/p' \
    | grep . \
    | grep -vP '^-' \
    | sed 's/: /=/' \
    | tr -d \' \
    | sed 's/=/="/' \
    | sed 's/$/"/' \
    | grep -v 'Audio_extra:\\n' \
    | sed 's/^\s\+/export Audio_/')

  # echo $VIDEOINFO

  #echo "$VIDEOINFO"
  #echo "$AUDIOINFO"

  #eval echo -e "$VIDEOINFO"
  #eval echo -e "$AUDIOINFO"

  while read LINE ; do
    # echo - $LINE -
    eval "$LINE" || echo Could not eval: "$LINE"
  done <<<$AUDIOINFO

  while read LINE ; do
    # echo - $LINE -
    eval "$LINE" || echo Could not eval: "$LINE"
  done <<<$VIDEOINFO

  echo $Video_BitRate
  echo $Audio_BitRate

}


echo -ne "$TITLE"

for VIDEO in $@ ; do
  if [ -f "$VIDEO" ]; then
    if false; then
      A=$(echo $(mediainfo --Inform='Audio;%BitRate%' "$VIDEO") $(mediainfo --Inform='Audio;%FromStats_BitRate%' "$VIDEO") 0 | awk '{ print $1 }')
      G=$(echo $(mediainfo --Inform='General;%BitRate%' "$VIDEO") $(mediainfo --Inform='General;%OverallBitRate%' "$VIDEO") 0 | awk '{ print $1 }')
      H="$(mediainfo --Inform='Video;%Height%' $VIDEO)"
      S=$(stat -c '%s' "$VIDEO")
      V=$(echo $(mediainfo --Inform='Video;%BitRate%' "$VIDEO") $(mediainfo --Inform='Video;%FromStats_BitRate%' "$VIDEO") 0 | awk '{ print $1 }')
      W="$(mediainfo --Inform='Video;%Width%' $VIDEO)"
      AC="$(mediainfo --Inform='Audio;%CodecID%' $VIDEO)"
      VC="$(mediainfo --Inform='Video;%CodecID%' $VIDEO)"
      if [ -n "$HUMAN" ]; then
        A=$(echo $A | numfmt --to=iec 2>/dev/null || echo 0)
        G=$(echo $G | numfmt --to=iec 2>/dev/null || echo 0)
        S=$(echo $S | numfmt --to=iec 2>/dev/null || echo 0)
        V=$(echo $V | numfmt --to=iec 2>/dev/null || echo 0)
      fi
      echo "$VIDEO $S $G $V $A ${W}x${H} $VC $AC"
    else
      process_video "$VIDEO"
    fi
  fi
done | $ALIGN
