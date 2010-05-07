#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  awesome-set-mixers.pl
#
#        USAGE:  ./awesome-set-mixers.pl 
#
#  DESCRIPTION:  sets up mixers in awesome
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  05/06/09 04:24:42 PDT
#     REVISION:  $id$
#===============================================================================

use strict;
use warnings;


my @mix = qw/Master PCM Front Rear Center Sub/;



for (@mix){
    my $mixer = `amixer get $_ | tail -n 1` || next;
    print $mixer;
    open (AWESOME, "| awesome-client") || die $!;
    print AWESOME " volwidget:bar_properties_set(\"$_\", " .
    "   { fg = '#AED8C6',               "    .
    "       fg_center = '#287755',      "    .
    "       fg_end = '#287755',         "    .
    "       fg_off = '#222222',         "    .
    "       vertical_gradient = true,   "    .
    "       horizontal_gradient = false,"    .
    "       ticks_count = 0,            "    .
    "       ticks_gap = 0 })            "
}




# vi: set ts=4 sw=4 et:

