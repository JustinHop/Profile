#!/bin/zsh
#===============================================================================
#
#          FILE:  checkwww.sh
# 
#         USAGE:  ./checkwww.sh 
# 
#   DESCRIPTION:  Checks websites
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#       COMPANY:  Universal Music Group
#       VERSION:  1.0
#       CREATED:  03/11/2010 06:16:00 PM PST
#      REVISION:  ---
#===============================================================================

if [[ -z $1 ]]; then 
	echo "Usage: $0 (sitename) <(hostname)> <(filename)>"
	exit 1;
fi

SITE=$1

if [[ -z $2 ]]; then
	HOST=$SITE
else
	HOST=$2
fi

if [[ -z $3 ]]; then
	FILE="/"
else
	FILE=$3
fi

echo "GET $FILE HTTP/1.1
Host: $HOST
Connection: Close

" | nc $HOST 80

