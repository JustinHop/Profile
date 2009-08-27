#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  apollo.pl
#
#        USAGE:  ./apollo.pl
#
#  DESCRIPTION:  run in directory containing dirs of lables with dirs of
#  sitelabeled dirs which contain files page, a wget of the page, wget_log wich
#  is the wget log, dc the dc id and google the google id
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  08/20/2009 01:28:25 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use File::Slurp;

foreach my $label (<*>) {
    next unless [ -d $label ];
    foreach my $site (<$label/*>) {
        next unless ( -d "$site" );
        next unless ( -f "$site/page" );
        next unless ( -f "$site/wget_log" );
        my $log = read_file("$site/wget_log");
        my ( $google, $smart );
        my $ip = "0.0.0.0";
        my $g  = "";
        my $dc = "";

        if ( $log =~ /Resolving.*\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/ ) {
            $ip = $1;
        }
        if ( -f "$site/dc" ) {
            $smart = read_file("$site/dc");
            if ( $smart =~ /var gDcsId="(\w+)"/ ) {
                $dc = $1;
            }
        }
        if ( -f "$site/google" ) {
            $smart = read_file("$site/google");
            if ( $smart =~ /(UA-\d{7}-\d{1,2})/ ) {
                $g = $1;
            }
        }

        $site =~ s!/!,!;
        print "$site,$dc,$g\n";

    }
}
