#!/bin/bash

BINDFORWARD="$HOME/tm.bindForward"

if [ -f "$1" ]; then
    BINDFORWARD="$1"
fi

if [ ! -f "$BINDFORWARD" ]; then
    echo "No bind forward file"
    exit 1
fi


cat $BINDFORWARD \
    | grep -P "\bIN\b\s*\bA\b" \
    | awk '{ print $5" "$1 }' \
    | sed 's/\.$//'
