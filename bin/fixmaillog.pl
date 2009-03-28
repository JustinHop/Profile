#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  fixmaillog.pl
#
#        USAGE:  ./fixmaillog.pl 
#
#  DESCRIPTION:  fixes the date on the mail logs
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  03/28/2009 06:46:02 PM GMT
#     REVISION:  $id$
#===============================================================================

use strict;
use warnings;

while(<>){
    if (/^(\d+)\.\d+\s+(.*)$/){ 
        my $unixtime=$1;
        my $rest=$2;
        my ($sec, $min, $hour, $mday,$mon,$year,$wday,$yday,$isdst) = localtime($unixtime);
        print $year.$mon.$mday.$hour.$min.$sec." ".$2."\n";
    }
}

# vi: set ts=4 sw=4 et:

