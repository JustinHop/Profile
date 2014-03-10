#!/bin/bash
#===============================================================================
#
#          FILE:  readonlytest.sh
# 
#         USAGE:  ./readonlytest.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@ticketmaster.com
#       COMPANY:  Live Nation
#       VERSION:  1.0
#       CREATED:  11/14/2013 09:00:34 PM PST
#      REVISION:  ---
#===============================================================================

RAND=$RANDOM
FILE=/tmp/.readonly-$RANDOM

if touch $FILE && rm $FILE ; then
    echo OK
else
    echo READ ONLY
fi

