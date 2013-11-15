#!/bin/bash
#===============================================================================
#
#          FILE:  makebindforward.sh
# 
#         USAGE:  ./makebindforward.sh 
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
#       CREATED:  11/14/2013 06:44:32 PM PST
#      REVISION:  ---
#===============================================================================

mv -v ~/tm.bindForward ~/.tm.bindForward.back

for zone in clisys.tmcs cloudsys.tmcs coresys.tmcs fieldsys.tmcs netops.tmcs netsys.tmcs stratsys.tmcs techops.tmcs tm.tmcs tw.tmcs uksys.tmcs vista.tmcs websys.tmcs winsys.tmcs syseng.tmcs
do
    dig @iib1.dns.dns2.cloudsys.tmcs $zone axfr >> ~/tm.bindForward
done


