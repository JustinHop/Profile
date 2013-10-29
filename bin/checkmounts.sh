#!/bin/bash
#===============================================================================
#
#          FILE:  checkmounts.sh
# 
#         USAGE:  ./checkmounts.sh 
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
#       CREATED:  05/22/2012 04:14:34 PM PDT
#      REVISION:  ---
#===============================================================================

for SCH in $@ ; do
        if mount | grep -q $SCH ; then
            echo $SCH found
        else
            echo $SCH NOT FOUND
        fi
done
