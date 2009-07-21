#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  tweet.pl
#
#        USAGE:  ./tweet.pl  
#
#  DESCRIPTION:  Gets latest twitter posts
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  Tue Jul  7 22:58:16 PDT 2009
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Net::Twitter;

my $pass;

open (PW,"<", $ENV{"HOME"} . "/.tweet") || die "No Password File (~/.tweet): $!";
while (<PW>){
    chomp;
    $pass = $_;
}
close PW;

my $nt = Net::Twitter->new(
        traits   => [qw/API::REST/],
        username => "Justin_Hop",
        password => $pass,
        );

my $update;

if ( $#ARGV >= 0 ) {
    $update = join(" ", @ARGV);
} else {
    while (<>){
        $update.=$_;
    }
}

my $result = $nt->update($update);

if ( my $err = $@ ) {
    die $@ unless blessed $err && $err->isa('Net::Twitter::Error');

    warn "HTTP Response Code: ", $err->code, "\n",
         "HTTP Message......: ", $err->message, "\n",
         "Twitter error.....: ", $err->error, "\n";
}


