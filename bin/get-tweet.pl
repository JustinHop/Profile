#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  get-tweet.pl
#
#        USAGE:  ./get-tweet.pl
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
use Data::Dumper;
use File::Slurp;

my $pass;
my $passfile = $ENV{"HOME"} . "/.tweet";

my $last = {};
my $lastfile = $ENV{"HOME"} . "/.lasttweet";
$last->{"count"} = 5;

if ( -r $passfile ) {
    $pass = read_file($passfile);
    chomp $pass;
} else {
    die "No Password File (~/.tweet): $!";
}

if ( -r $lastfile ) {
    $last->{"since_id"} = read_file($lastfile);
    write_file( $lastfile, @{$last->{since_id}} );
} 

my $nt = Net::Twitter->new(
    traits   => [qw/API::REST/],
    username => "Justin_Hop",
    password => $pass,
);

my $statuses;

eval {
    $statuses = $nt->friends_timeline();
    for my $status ( @$statuses ) {
        print "$status->{time} <$status->{user}{screen_name}> $status->{text}\n";
    }
};

if ( my $err = $@ ) {
    die $@ unless blessed $err && $err->isa('Net::Twitter::Error');

    warn "HTTP Response Code: ", $err->code, "\n",
      "HTTP Message......: ", $err->message, "\n",
      "Twitter error.....: ", $err->error,   "\n";
} else {
    print Dumper($statuses);
}

