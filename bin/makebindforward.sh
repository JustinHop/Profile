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
#       CREATED:  08/28/2013 11:48:45 AM PDT
#      REVISION:  ---
#===============================================================================


mv -v ~/tm.bindForward ~/.tm.bindForward.back

#for zone in clisys.tmcs cloudsys.tmcs coresys.tmcs fieldsys.tmcs netops.tmcs netsys.tmcs stratsys.tmcs techops.tmcs tm.tmcs tw.tmcs uksys.tmcs vista.tmcs websys.tmcs winsys.tmcs syseng.tmcs
for zone in clisys.tmcs cloudsys.tmcs coresys.tmcs fieldsys.tmcs netops.tmcs netsys.tmcs stratsys.tmcs techops.tmcs tw.tmcs uksys.tmcs vista.tmcs websys.tmcs winsys.tmcs syseng.tmcs tm.tmcs
do
    echo $zone | tee /dev/stderr
    #dig @10.75.32.5 $zone axfr >> ~/tm.bindForward
done | xargs -n1 -P4 -I{} dig @10.75.32.5 {} axfr >> ~/tm.bindForward

sed -i '/\.tm\.tmcs\.\s+/d' ~/tm.bindForward


