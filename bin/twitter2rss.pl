#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  twitter2rss.pl
#
#        USAGE:  ./twitter2rss.pl
#
#  DESCRIPTION:  Will convert my friends timeline to an rss feed.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  11/08/2009 09:35:57 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Data::Dumper;
use Net::Twitter;
use XML::RSS;

my $rss = XML::RSS->new( version => '2.0' );
my $user = 'Justin_Hop';
my $pass;

open( PW, "<", $ENV{"HOME"} . "/.tweet" )
  || die "No Password File (~/.tweet): $!";
while (<PW>) {
    chomp;
    $pass = $_;
}
close PW;

my $nt = Net::Twitter->new(
    traits   => [qw/API::REST/],
    username => $user,
    password => $pass
);

$rss->channel(
    title    => "Twitter Updates for $user",
    link     => "http://twitter.com/$user",
    language => 'en',
    description =>
      "Twitter updates from Justin Hoppensteadt / Justin_Hop and folks.",
    rating => '(PICS-1.1 "http://www.classify.org/safesurf/" 1 r (SS~~000 1))',
    copyright => 'Copyright 1999, Freshmeat.net',
);

my $r = $nt->friends_timeline;
for my $status (@$r) {
    $rss->add_item(
        title       => $status->{user}->{name} . ": " . $status->{text},
        description => '<a href="'
          . $status->{user}->{url} . '">'
          . $status->{user}->{name}
          . '<img src="'
          . $status->{user}->{profile_image_url}
          . '"> : </a>'
          . $status->{text}
          . ' at ' . $status->{created_at}
    );
}

my @lines = split(/\n/, $rss->as_string);

foreach (@lines){
    s/&#x3C;/</g;
    s/&#x22;/"/g;
    s/&#x3E;/>/g;
    print $_ . "\n";
}

