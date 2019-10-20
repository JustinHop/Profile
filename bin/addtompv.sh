#!/bin/bash
set -x

set -euo pipefail
IFS=$'\n\t'

SOCKET=/tmp/mpvsocket

for LINK in "$@" ; do
    echo $LINK
    echo "loadfile $LINK append-play" | socat - $SOCKET
    echo "print-text \"appended $LINK\"" | socat - $SOCKET
    echo "show-text \"appended $LINK\"" | socat - $SOCKET
done
