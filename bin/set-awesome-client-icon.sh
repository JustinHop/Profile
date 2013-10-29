#!/bin/bash
#===============================================================================
#
#          FILE:  set-awesome-client-icon.sh
<<<<<<< HEAD
# 
#         USAGE:  ./set-awesome-client-icon.sh 
# 
#   DESCRIPTION:  sets tag icon to client icon, plus waiting
# 
=======
#
#         USAGE:  ./set-awesome-client-icon.sh
#
#   DESCRIPTION:  This should set the icon for the tag to the focused windows icon
#   mostly
#
>>>>>>> 16739dea6be68c854a294099097e551c430cc2f9
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
echo "if client.focus then awful.tag.seticon(client.focus.icon) else awful.tag.seticon() end" | awesome-client &
<<<<<<< HEAD
=======
#
#how its done on the old tux
#( awesome-client < ~/Profile/awesome/tagset.lua ) &
>>>>>>> 16739dea6be68c854a294099097e551c430cc2f9
