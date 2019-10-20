#!/bin/zsh
set -euo pipefail
#IFS=$'\n\t'

GEN=""
AUD=""
VID=""
HUMAN=""

while getopts "gavh" opt; do
  case ${opt} in
    a ) AUD=1
      ;;
    g ) GEN=1
      ;;
    v ) VID=1
      ;;
    h ) HUMAN=1
      ;;
    * ) echo "$0 [-g] [-v] [-a] [-h] <FILE>..."
        exit 1
      ;;
  esac
done
shift $((OPTIND -1))

for VIDEO in $@ ; do
    if [ -f "$VIDEO" ]; then
        A=$(mediainfo --Inform='Audio;%BitRate%' "$VIDEO" || echo 0)
        G=$(mediainfo --Inform='General;%BitRate%' "$VIDEO" || echo 0)
        V=$(mediainfo --Inform='Video;%BitRate%' "$VIDEO" || echo 0)

        if [ -n "$HUMAN" ]; then
            A=$(echo $A | numfmt --to=iec || echo 0)
            G=$(echo $G | numfmt --to=iec || echo 0)
            V=$(echo $V | numfmt --to=iec || echo 0)
        fi

        if [ -z "$GEN" ] && [ -z "$AUD" ] && [ -z "$VID" ] ; then
            echo "$VIDEO\t$G\t$V\t$A"
        else
            echo -n "$VIDEO"
            if [ -n "$GEN" ]; then
                echo -n "\t$G"
            fi
            if [ -n "$VID" ]; then
                echo -n "\t$V"
            fi
            if [ -n "$AUD" ]; then
                echo -n "\t$A"
            fi
            echo
        fi
    fi
done

