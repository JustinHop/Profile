#!/bin/bash
#===============================================================================
#
#          FILE:  mplayer-delete.sh
# 
#         USAGE:  ./mplayer-delete.sh 
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
#       CREATED:  01/01/2014 10:30:28 PM PST
#      REVISION:  ---
#===============================================================================

OUTFILE=/tmp/delete-candidates

# On multiuser machines, output and grep on $USER too
MYPID=$(pgrep -x mplayer | sort | tail -n 1)

if [ "$(echo ${MYPID}|wc -w)" -ne 1 ] ; then
echo "#no safe output: too many PIDs: \"${MYPID}\" ($(echo ${MYPID}|wc -c))"
exit 1
fi

IFS='
'
for FILE in $(lsof -p ${MYPID} -Ftn |grep -A1 ^tREG|grep ^n|sed 's/^n//g') ; do
if test -w "${FILE}" ; then
    if echo "${FILE}" | grep -sq '/media/terra' ; then
        echo "${FILE}" | tee -a ${OUTFILE}
    fi
fi
done


