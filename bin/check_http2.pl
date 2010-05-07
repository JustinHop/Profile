#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  check_http2.pl
#
#        USAGE:  ./check_http2.pl  
#
#  DESCRIPTION:  Wraps nagiso check_http
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  11/03/2009 12:58:16 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Term::ANSIColor qw(:constants);

my $check = '/usr/lib/nagios/plugins/check_http';

while (<STDIN>){
    chomp;
    my $site = $_;
    print WHITE, $_ ;
    my	$IN_command = "$check -H $site --invert-regex -R 'warning|error' | ";		# pipe command

        open  my $IN, $IN_command
        or die  "$0 : failed to open  pipe '$IN_command' : $!\n";

    close  $IN
        or warn "$0 : failed to close pipe '$IN_command' : $!\n";

}


