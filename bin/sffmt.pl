#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  sffmt.pl
#
#        USAGE:  ./sffmt.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  09/23/2009 12:08:00 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;


while (<stdin>){
    chomp;
    my @p = split(/\|/, $_);
    for (@p) {
        #print $_ . "\n";
    }
    print $p[0] . "\t" . $p[1] . "\t" . "<b>" . $p[0] . "<\b><br />" . $p[1] . "<br />" . $p[2] . "<br />\n"; 
}

