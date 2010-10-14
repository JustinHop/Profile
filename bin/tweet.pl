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

my $access_token;
my $access_token_secret; 

open (PW,"<", $ENV{"HOME"} . "/.tweet") || die "No Password File (~/.tweet): $!";
while (<PW>){
    chomp;
    ($access_token,$access_token_secret) = split(':');
}
close PW;

my $consumer_key = 'cbXRR0ZCqjakf98IbI6A';
my $consumer_secret = 'To20mhtdpgKjlPc4QEe4imZ8ZHaJt6183x7ofCkQysc';

         my $nt = Net::Twitter->new(
             traits   => [qw/OAuth API::REST/],
             consumer_key        => $consumer_key,
             consumer_secret     => $consumer_secret,
             access_token        => $access_token,
             access_token_secret => $access_token_secret,
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


