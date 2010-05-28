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
Host: $SITE
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.2) Gecko/20100316 Firefox/3.6.2
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-us,en;q=0.5
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7
Connection: Close

" | nc $HOST 80

