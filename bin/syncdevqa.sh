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

ssh ops1.sys.devqa1.websys.tmcs '/ops/local/bin/cluster_software_update; rsync -av --delete --exclude=.snapshot/ /mnt/software_sync/AS5/ /mnt/volsw_dev/AS5'

ssh ops2.sys.devqa1.websys.tmcs '/ops/local/bin/cluster_software_update ; rsync -av --exclude=.snapshot/ /mnt/software_sync/AS5/ /software'
