#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  f.pl
#
#        USAGE:  ./f.pl  
#
#  DESCRIPTION:  reads include outs zsh functions
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  08/07/2009 04:44:15 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

my $file = 0;

while (<STDIN>){
    if ( (/^(\w+)\(\) {/) && ($file == 0 ) ){
        $file = $1;
        next;
    }
    if ( /^}/ ) {
        $file = 0;
        next;
    }
    if ( $file =~ /\w/ ) {
        print $file . ":";
        print system("tee -a zsh/$file << EOF
$_
EOF");
    }
}

