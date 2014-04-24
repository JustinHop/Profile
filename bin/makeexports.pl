#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  makeexports.pl
#
#        USAGE:  ./makeexports.pl  
#
#  DESCRIPTION:  makes exports
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@ticketmaster.com
#      COMPANY:  Live Nation
#      VERSION:  1.0
#      CREATED:  10/14/2011 02:40:00 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

my $real = "t501_1_fls1_vol0";
my $network = "10.73.100.0/22";

while (<>) {
    my ($class,$product,$cluster);
    chomp;
    #print $_ . "\n";
    /^(\w+)\d+\.(\w+)\.(\w+).*$/ && do {
        $class=$1;
        $product=$2;
        $cluster=$3;
        #print "class=$class\nproduct=$product\ncluster=$cluster\n";

        print "/vol/vol0/websys-$cluster-$product-$class\t\t" .
            "-actual=/vol/$real/websys-$cluster-$product-$class,sec=sys,rw=$network,root=$network\n";
    }
}



