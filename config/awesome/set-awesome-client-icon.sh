#!/bin/bash
#===============================================================================
#
#          FILE:  set-awesome-client-icon.sh
# 
#         USAGE:  ./set-awesome-client-icon.sh 
# 
#   DESCRIPTION:  sets tag icon to client icon, plus waiting
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@ticketmaster.com
#       COMPANY:  Live Nation
#       VERSION:  1.0
#       CREATED:  11/16/2012 12:25:36 PM PST
#      REVISION:  ---
#===============================================================================

sleep .01s
#
cat ~/Profile/config/awesome/icon.lua | awesome-client
#
#how its done on the old tux
#( awesome-client < ~/Profile/awesome/tagset.lua ) &
