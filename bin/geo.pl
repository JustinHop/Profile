#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  geo.pl
#
#        USAGE:  ./geo.pl  
#
#  DESCRIPTION:  Spits back geo coordantes
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  10/01/2009 04:55:16 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;


use Geo::Coder::Google;

my $geocoder =
  Geo::Coder::Google->new( apikey =>
'ABQIAAAAuor-ynygw3fozPCAL4MR5xS7Xo8NY-MtKNarYeOvpL9OFgk-uxT_WWVhSMpWKlGdrG6EQo6BtQK1RA'
  );

while (<>) {


    chomp;
    my $location = $geocoder->geocode( location => $_ );

    print "'"
      . $location->{'Point'}->{'coordinates'}[1] . "','"
      . $location->{'Point'}->{'coordinates'}[0] . "'\n";

}

