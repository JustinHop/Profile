#!/bin/bash
#===============================================================================
#
#          FILE:  syncdevqa.sh
# 
#         USAGE:  ./syncdevqa.sh 
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
#       CREATED:  05/06/2013 01:28:20 PM PDT
#      REVISION:  ---
#===============================================================================

nhs | grep -P 'ops\d+\.sys\.devqa\d+\.websys\.tmcs' | onall -t 3600 -Qpb "/ops/local/bin/cluster_software_update $@"
