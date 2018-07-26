#!/bin/bash

FAN=/proc/acpi/ibm/fan
STATUS=$(cat $FAN | grep -P '^level:' | awk '{ print $2 }')
SPEED=$(cat $FAN | grep -P '^speed:' | awk '{ print $2 }')


ARG="full-speed"

if [ "$STATUS" == "full-speed" ]; then
    ARG="auto"
fi

echo "Currently $STATUS at $SPEED rpm; setting to $ARG"
echo "level $ARG" | sudo tee $FAN
cat $FAN | grep -v command
