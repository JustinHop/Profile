#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  cluster-setup.pl
#
#        USAGE:  ./cluster-setup.pl  
#
#  DESCRIPTION:  Takes arguements from stdin. Sets up clusters on local ops box.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@ticketmaster.com
#      COMPANY:  Live Nation
#      VERSION:  1.0
#      CREATED:  10/06/2011 01:39:39 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

my $real = "t525_2_fls1";


while (<>) {
    my ($class,$product,$cluster);
    chomp;
    #print $_ . "\n";
    /^(\w+)\d+\.(\w+)\.(\w+).*$/ && do {
        $class=$1;
        $product=$2;
        $cluster=$3;
        #print "class=$class\nproduct=$product\ncluster=$cluster\n";


#       print "ssh fls1 \"qtree create /vol/". $real . "_vol0/websys-$cluster-cluster\"\n" .
#           "mkdir -m 755 /fls1/vol0/websys-$cluster-cluster\n" .
#           "chown tmweb:tmweb /fls1/vol0/websys-$cluster-cluster\n" .
#           "ssh fls1 \"qtree create /vol/" . $real . "_vol0/websys-$cluster-$product-$class\"\n" .
#           "mkdir -m 755 /fls1/vol0/websys-$cluster-$product-$class/{1,2,shared}\n" .
#           "chown tmweb:tmweb /fls1/vol0/websys-$cluster-$product-$class/{1,2,shared}\n";

        print "ssh fls1 \"exportfs /vol/vol0/websys-$cluster-$product-$class\"\n";

    } ;



}

