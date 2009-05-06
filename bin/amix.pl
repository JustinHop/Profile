#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  amix.pl
#
#        USAGE:  ./amix.pl 
#
#  DESCRIPTION:  returns simple sound vals
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  05/06/09 08:09:51 PDT
#     REVISION:  $id$
#===============================================================================

use strict;
use warnings;

my $vol = {};

open (MIX, "amixer |");

while(<MIX>){
    if ( /^Simple mixer control '([^']+)',0/ ){
        $vol->{'last'}= $1;
        next;
    }else{
        if (/^\s+([^:]+): Playback \d+ \[(\d+)\%\]/){
            $vol->{$vol->{'last'}}->{$1} = $2;
            next;
        }
    }
}

for (@ARGV) {
    my $arg = $_;
    if ( defined $vol->{$arg} ){
        for (keys %{ $vol->{$arg} } ){
            print $arg . ":" . $_ . ":" . $vol->{$arg}->{$_} . "\n";
        }
    }else {
        exit 1;
    }
}





# vi: set ts=4 sw=4 et:

