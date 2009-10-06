#!/bin/bash
#===============================================================================
#
#          FILE:  UNrar.sh
# 
#         USAGE:  ./UNrar.sh 
# 
#   DESCRIPTION:  Unrars multipart rars
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#       COMPANY:  Universal Music Group
#       VERSION:  1.0
#       CREATED:  10/06/2009 09:13:27 AM PDT
#      REVISION:  ---
#===============================================================================

$DIR = "~/storage/x";

if [ "$1" ]; then
	if [ -d "$1" ]; then
		$DIR="$1"
	fi
fi

for i in $(/bin/ls "$DIR/*part1.rar" | tac) ; do 
	echo $i 
	if [ -e $i.worked ] ; then 
		echo ALREADY
    else 
    	if unrar e $i ; then
            touch $i.worked 
            echo touched $i.worked
        fi
    fi 
done

