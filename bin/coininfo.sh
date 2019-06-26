#!/bin/bash
#===============================================================================
#
#          FILE:  coininfo.sh
#
#         USAGE:  ./coininfo.sh
#
#   DESCRIPTION:  Gets crypto currency updates from cryptocoincharts.info
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@ticketmaster.com
#       COMPANY:  Live Nation
#       VERSION:  1.0
#       CREATED:  12/03/2013 11:43:06 AM PST
#      REVISION:  ---
#===============================================================================

WGET="wget --quiet http://www.cryptocoincharts.info -O-"

BTCUSD="sed -n -e '/\*\*\*\*\* BTC\/USD/,/\*\*\*\*\*/p' | sed 's/^\(.\{53\}\).*/\1/' | head -n -1"

