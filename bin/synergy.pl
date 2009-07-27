#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  synergy.pl
#
#        USAGE:  ./synergy.pl 
#
#  DESCRIPTION:  this will wrap around synergy and update the mouse box when on
#  tux-ninja
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  05/12/2009 02:06:25 PM PDT
#     REVISION:  $id$
#===============================================================================

use strict;
use warnings;

my $debug = 0;
my $last = "";

open (SYNERGY, "synergys -f -d INFO -c /etc/synergys.conf 2>&1 |") || die $!;

while (<SYNERGY>){
    print;
    $last = $_;
    if (/^INFO: CServer\.cpp\S+: switch from "([^"]+)" to "([^"]+)"/){
        my $two = $2;
        open(AWESOME, "| awesome-client") || die $!;
        if ($two =~ /tux-ninja/){
            print AWESOME "settings.synergylocal=0\n";
            print STDERR "Synergy Local\n" if $debug;
        } else {
            print AWESOME "settings.synergylocal=1\n";
            print STDERR "Synergy Remote\n" if $debug;
        }
    }
}

if ( $last =~ /CServer.cpp:442: void CServer/ ) {
    exec $0
}


warn "$0 has exited";
# vi: set ts=4 sw=4 et:

