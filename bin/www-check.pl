#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  www-check.pl
#
#        USAGE:  cat bunchofsites | ./www-check.pl host (hosts)
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
use Mojo::URL;

help() unless ( $#ARGV > 0 );

my $debug = 1;

while (<STDIN>) {
    for (split(" ")){
        check($_);
        print "\n";
    }
}


sub check {
	my	( $url )	= Mojo::URL->new("http://$_") || return;
    if ( $url->host ){
        print "Testing : " . $_ . "\n";
    }else{
        print "Bad : $_\n" if $debug;
    }
    for my $hostaddr (@ARGV) {
        print "\t$hostaddr = ";
        my $s = Net::HTTP->new(
            PeerAddr => $hostaddr,
            Host     => $url->host,
        ) || ( print "bad\n" &&  next );
        $s->write_request( GET => $url->path, 'User-Agent' => "Mozilla/5.0" );
        my ( $code, $mess, %headers ) = $s->read_response_headers();
        print $code . " \"" . $mess . " \"  ";
        if ( ( $code =~ /^3\d\d/ ) && ( exists $headers{"Location"} ) ) {
            print " = " . $headers{"Location"} . "\n";
        }
    }
	return ;
}	# ----------  end of subroutine check  ----------

sub help {
    print "$0: [host] ..[ (host.. host)] < file_containing_hostnames\n";
    die "User error: $!";
}

