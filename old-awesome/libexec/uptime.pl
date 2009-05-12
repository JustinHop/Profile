#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  uptime.pl
#
#        USAGE:  ./uptime.pl 
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  04/03/2009 07:11:44 PM PDT
#     REVISION:  $id$
#===============================================================================

use strict;
use warnings;

 20 
 21 use strict;
 22 use warnings;
 23 
 24 print "Launching Awesome Monitor Updater\n";
 25 open (AWE, "| awesome-control")|| die $!;
 26 
 27 
 28 while ( -p ( $ENV{'HOME'} . '.awesome_ctl.0' ) ) { 
 29     
 30     my $out = '"<color=grey><small>load</small></color> " .. ldotbox[s] .. </color>
 31     
 32     my @loads = split(" ", `cat /proc/loadavg`);
 33     
 34     foreach
 35 
 36 
 37 
 38 



# vi: set ts=4 sw=4 et:

