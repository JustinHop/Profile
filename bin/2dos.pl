#!/usr/bin/perl
#===============================================================================
#
#         FILE:  2dos.pl
#
#        USAGE:  ./2dos.pl  
#
#  DESCRIPTION:  pipe unix2dos
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  09/30/2009 01:02:52 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

while (<stdin>){
    chomp;
    print $_ . "\n";
}
