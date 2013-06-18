#!/bin/bash
#===============================================================================
#
#          FILE:  oncall-report.sh
# 
#         USAGE:  ./oncall-report.sh 
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
#       CREATED:  11/19/2011 06:08:40 PM PST
#      REVISION:  ---
#===============================================================================

#/ops/shared/bin/websys_top_classes -s "2011-10-01 07:00:00" -f "2011-10-01 07:15:00"

CMD=/ops/shared/bin/websys_top_classes 
DATE=`date +%F`
#DATE="2012-04-28"
H=ops1.sys.ash1.websys.tmcs


ssh $H $CMD -s \"$DATE 06:55:00\" -f \"$DATE 07:15:00\"
ssh $H $CMD -s \"$DATE 07:55:00\" -f \"$DATE 08:15:00\"
ssh $H $CMD -s \"$DATE 08:55:00\" -f \"$DATE 09:15:00\"
ssh $H $CMD -s \"$DATE 09:55:00\" -f \"$DATE 10:15:00\"
#ssh $H $CMD -s \"$DATE 10:55:00\" -f \"$DATE 11:15:00\"
#ssh $H $CMD -s \"$DATE 11:55:00\" -f \"$DATE 12:15:00\"

