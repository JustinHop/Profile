#!/bin/bash
#===============================================================================
#
#          FILE:  externalip.sh
# 
#         USAGE:  ./externalip.sh 
# 
#   DESCRIPTION:  gets your external ip
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@ticketmaster.com
#       COMPANY:  Live Nation
#       VERSION:  1.0
#       CREATED:  04/02/2013 08:17:25 AM PDT
#      REVISION:  ---
#===============================================================================

tsocks nc v4address.com 23 | tail -n 1 | awk '{ print $5 }'

