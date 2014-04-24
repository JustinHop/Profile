#!/bin/bash
#===============================================================================
#
#          FILE:  getuvtotal.sh
# 
#         USAGE:  ./getuvtotal.sh 
# 
#   DESCRIPTION:  Gets TMOL concurrent sessions from UV
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@ticketmaster.com
#       COMPANY:  Live Nation
#       VERSION:  1.0
#       CREATED:  06/01/2012 09:10:45 AM PDT
#      REVISION:  ---
#===============================================================================

TMOL=$(echo -e "GET / HTTP/1.1\nHost: uv.websys.tmcs\nConnection: Close\n\n" \
    |nc uv.websys.tmcs 80 | grep -oP 'TMOL: \d+')


echo "`date`: $TMOL"
