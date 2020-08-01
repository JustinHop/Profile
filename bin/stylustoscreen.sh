#!/bin/zsh

set -euo pipefail
IFS=$'\t\n'

#set -x
WACOMFILE=/tmp/wacom

dowacom(){
    VER=""

    OUTPUT="eDP-1"

    if (( $# == 1 )) ; then
        SCREEN=$1
        if (( SCREEN==1 )); then
            OUTPUT="eDP-1"
        elif (( SCREEN==3 )); then
            OUTPUT="DP-2-2"
        elif (( SCREEN==2 )); then
            OUTPUT="DP-2-1"
        fi
    else
        IFS=$' \t\n' && for LINE in $(xdotool getmouselocation) ; do
            eval export WACOM_${LINE:s/:/=/}
        done

        POS=$WACOM_x

        [ "$POS" ] || exit

        if (( $POS>3840 )) ; then
            OUTPUT="DP-2-1"
        elif (( $POS>1920 )) ; then
            OUTPUT="DP-2-2"
        else
            OUTPUT="eDP-1"
        fi
    fi

    [ "$VER" ] && echo $OUTPUT

    if [ ! -f $WACOMFILE ] ; then
        xsetwacom --list devices > $WACOMFILE
    fi

    for DEVICE in $(cat $WACOMFILE | cut -d: -f2 | awk '{ print $1 }') ; do
        [ "$VER" ] && echo $DEVICE
        xsetwacom --set $DEVICE MapToOutput $OUTPUT &
    done
}

dowacom &

