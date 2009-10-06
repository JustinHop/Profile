#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  geocodesf.pl
#
#        USAGE:  ./geocodesf.pl
#
#  DESCRIPTION:  Geocode sf
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  10/01/2009 02:05:55 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Data::Dumper;

use Geo::Coder::Google;

my $geocoder =
  Geo::Coder::Google->new( apikey =>
'ABQIAAAAuor-ynygw3fozPCAL4MR5xS7Xo8NY-MtKNarYeOvpL9OFgk-uxT_WWVhSMpWKlGdrG6EQo6BtQK1RA'
  );
while (<STDIN>) {

    #m{<b>(.*)</b><br />([^<]+)<br />(\(\d{3}\) \d{3}-\d{4})<br />};
    #m!^([^\t]+)\t([^\t]+)!;
    m!^([^\t]+)\t([^\t]+)\t(.*)<!;

    my $name    = $1;
    my $address = $2;
    my $info    = $3;

    my $location = $geocoder->geocode( location => $address );

    #print Dumper($location);

    my $line = "CreateMarker('"
      . $location->{'Point'}->{'coordinates'}[0] . "','"
      . $location->{'Point'}->{'coordinates'}[1] . "','$info','googlegreen.png',true,true);\n";

    $line =~ s!<br !</b><br!;
    print $line;


}

