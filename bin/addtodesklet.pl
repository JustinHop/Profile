#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  addtodesklet.pl
#
#        USAGE:  ./addtodesklet.pl 
#
#  DESCRIPTION:  run from file explorer to add picture to file list for 
#               photo desklets
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  02/11/2009 01:22:58 PM PST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

my $list = $ENV{'HOME'} . '/.desklets/photo-0.0.5/files.list';
my $out;

foreach my $file (@ARGV) {
    if ( $file =~ / / ) {
        my $link = $file;
        $link =~ s/ /_/g;
        system ("ln -s $file $link");
        $out = $link;
    }   else    {
        $out = $file;
    }
}

open ( LIST, ">> $list" ) || exit  1;
print LIST $out . "\n";
close LIST;


