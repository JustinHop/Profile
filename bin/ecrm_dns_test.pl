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
#     REVISION:  $Id$
#===============================================================================

use strict;
use warnings;

use Net::DNS;

my $QUIET;
$QUIET = 1 if $ENV{'QUIET_DNS'};

die "Usage: $0 <zone> [<zone>, <zone>...]" unless $ARGV[0];

my @look = (
    "",                     "pobox",
    "zone._domainkey",      "ukromlxmx01",
    "ukromlxmx01.internal", "usfshlxmx06",
    "usfshlxmx06.internal", "usfshlxmx07",
    "usfshlxmx07.internal", "usfshlxmx08",
    "usfshlxmx08.internal",
);

foreach my $zone (@ARGV) {
    print "!!!\n!!! ZONE LOOKUP FOR $zone\n!!!\n\n\n";
    foreach my $add (@look) {
        my @d = ( "$zone.myreg.net", "$zone.musicreg.net" );
        my @types = ( 'A', 'MX', 'TXT' );
        if ( $add =~ /^u/ ) { @types = ('A'); }
        if ( $add =~ /_domainkey/ ) { @types = ('TXT'); $add =~ s/zone/$zone/; }
        foreach my $type (@types) {
            foreach my $D (@d) {
                my $lookup = "$add.$D";
                if ( $add =~ /^$/ )      { $lookup = $D; }
                if ( $D   =~ /^\.(.+)/ ) { $lookup = $1; }
                my $res = resolve( $lookup, $type );
                print $res . "\n" if $res;
            }
        }
    }
}

sub resolve {
    my ( $lookup, $type ) = @_;
    my $res = Net::DNS::Resolver->new;
    my $return;
    $return = "Looking up $type record for $lookup\n" unless $QUIET;

    my $query;
    if ($type) {
        $query = $res->search( $lookup, $type );
    } else {
        $query = $res->search($lookup);
    }

    if ($query) {
        foreach my $rr ( $query->answer ) {
            my $string = $rr->string;
            foreach my $line ( split( "\n", $string ) ) {
                $return .= $line . "\n";
                if ( $line =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/ ) {
                    my $lookup = $1;
                    my $reverse = resolve( $lookup, $type );
                    $return .= $reverse if $reverse;
                }
            }
        }
    } else {
        $return .= $res->errorstring . "\n" unless $QUIET;
    }
    return $return;
}

