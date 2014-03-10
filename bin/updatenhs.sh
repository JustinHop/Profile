#!/bin/bash
#===============================================================================
#
#          FILE:  updatenhs.sh
#
#         USAGE:  ./updatenhs.sh
#
#   DESCRIPTION:  makes a better tm.bindForward
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@ticketmaster.com
#       COMPANY:  Live Nation
#       VERSION:  1.0
#       CREATED:  06/20/2012 06:07:59 PM PDT
#      REVISION:  ---
#===============================================================================

ssh dns1.sys.tools1.websys.tmcs grep -P \'"\s(A|CNAME)\s"\' /chroot/named/var/named/pz/*.tmcs | \
    cut -d/ -f7- | grep -vP '^;' | grep -v .tm.tmcs |\
    perl -ne '/^(\S+):(\S+)\s+((A|CNAME).*)/; print $2 . "." . $1 . ". 3600 IN  " . $3 . "\n"' > ~/tm.bindForward

