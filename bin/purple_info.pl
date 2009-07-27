#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  purple_info.pl
#
#        USAGE:  ./purple_info.pl 
#
#  DESCRIPTION:  Gets an account name then returns an alias and icon
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  05/05/2009 04:28:26 PM PDT
#     REVISION:  $id$
#===============================================================================

use strict;
use warnings;

use XML::Simple;

use Data::Dumper;

my $debug = 1;

my $blist = $ENV{'HOME'} . "/.purple/blist.xml";

my $conf = XMLin($blist) or die $!;


foreach (@ARGV) {
    foreach my $a (keys %{ $conf->{'blist'}->{'group'} } ){
        print "$a -> \n" if $debug;
        foreach my $b ( $conf->{'blist'}->{'group'}->{$a}->{'contact'} ) {
            print "ref b = " . ref($b) . "\n";
            print Dumper($b);
        }



    }
}


sub recurse {
    my $hashref = shift;
    #print "ref of \$harref " . ref($hashref) . "\n";
}

print Dumper($conf);

# vi: set ts=4 sw=4 et:

