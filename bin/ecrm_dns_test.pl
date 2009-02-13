#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  dnstest.pl
#
#        USAGE:  ./dnstest.pl 
#
#  DESCRIPTION:  This checks given zones for dns entries
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <justin.hoppensteadt@umgtemp.net>
#      COMPANY:  Universal Music Group, Inc.
#      VERSION:  1.0
#      CREATED:  02/12/2009 11:37:25 PM GMT
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Net::DNS;

die "Usage: $0 <zone> [<zone>, <zone>...]" unless $ARGV[0];

my @look = ( "", "pobox", "zone._domainkey",
    "ukromlxmx01", "ukromlxmx01.internal",
    "usfshlxmx06", "usfshlxmx06.internal",
    "usfshlxmx07", "usfshlxmx07.internal",
    "usfshlxmx08", "usfshlxmx08.internal",
);

my $res = Net::DNS::Resolver->new;

foreach my $zone (@ARGV){
	print "!!!\n!!! ZONE LOOKUP FOR $zone\n!!!\n\n\n";
    foreach my $add (@look){
        my @d = ( "$zone.myreg.net", "$zone.musicreg.net" );
        my @types = ( 'A', 'MX', 'TXT' );
        if ($add =~ /^u/) { @types = ( 'A' );}
        if ($add =~ /_domainkey/) { @types = ( 'TXT' ); $add =~ s/zone/$zone/;}
        foreach my $type (@types){
            foreach my $D (@d){
                my $lookup = "$add.$D";
                if ($add =~ /^$/) { $lookup = $D;}
                if ($D =~ /^\.(.+)/) { $lookup = $1; }
                my $query = $res->search($lookup, $type);

                print "Looking up $type record for $lookup\n";

                if ($query) {
                    foreach my $rr ($query->answer) {
                        print $rr->string . "\n";
                    }
                }   else    {
                    print $res->errorstring . "\n";
                }

                print "\n";
            }
        }
    }
}

