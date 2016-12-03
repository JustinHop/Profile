#!/bin/bash
set -x

COUNT=0
INPORT1=6600
TOPORT1=6601
TOPORT2=6602

OPTS="-d"


trap handle_trap USR1 HUP USR2

handle_trap () {
    pgrep -P $SOPID
    pkill -P $SOPID
    pkill -9 -P $SOPID
    kill $SOPID
}

while true ; do
      let "COUNT++"
      notify-send -i /usr/share/icons/HighContrast/48x48/devices/audio-headset.png -a mpd "Toggle MPD Port to $TOPORT1" "Connecting to port $TOPORT1 MPD"
      #nc6 --continuous -l -p $INPORT1 -e "nc6 localhost $TOPORT1" &
      socat $OPTS TCP-LISTEN:${INPORT1},reuseaddr TCP:localhost:${TOPORT1} &
      SOPID=$!
      wait $SOPID
      pkill -P $SOPID
      sleep 1s
      notify-send -i /usr/share/icons/HighContrast/48x48/devices/audio-headset.png -a mpd "Toggle MPD Port to $TOPORT2" "Connecting to port $TOPORT2 Mopidy"
      #nc6 --continuous -l -p $INPORT1 -e "nc6 localhost $TOPORT2" &
      socat $OPTS TCP-LISTEN:${INPORT1},reuseaddr  TCP:localhost:${TOPORT2} &
      SOPID=$!
      wait $SOPID
      pkill -P $SOPID
      sleep 1s
      echo "Toggle count $COUNT"
done
