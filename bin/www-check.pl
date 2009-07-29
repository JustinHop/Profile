#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  webcheck.pl
#
#        USAGE:  ./webcheck.pl
#
#  DESCRIPTION:
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  07/20/2009 04:52:14 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Net::HTTP;

help() unless ( $#ARGV > 0 );

my $debug = 1;

while (<STDIN>) {
    my $url = $_;
    if ( $_ =~ /^\s*(\S+)\s*$/) {
        $url = $1;
        print "Testing : $1\n";
    } else {
        print "Bad : $_\n" if $debug;
        next;
    }
    for my $hostaddr (@ARGV) {
        print "\thost : $hostaddr = ";
        my $s = Net::HTTP->new(
            PeerAddr => $hostaddr,
            Host     => $url
        ) || ( print "bad\n" &&  next );
        $s->write_request( GET => "/", 'User-Agent' => "Mozilla/5.0" );
        my ( $code, $mess, %headers ) = $s->read_response_headers();
        print $code . " \"" . $mess . " \"\n";
    }
}

sub help {
    print "$0: [host] ..[ (host.. host)] < file_containing_hostnames\n";
    die "User error: $!";
}

