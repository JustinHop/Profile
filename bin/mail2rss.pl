#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  mail2rss.pl
#
#        USAGE:  cat mail | ./mail2rss.pl 
#
#  DESCRIPTION:  Takes mail as input, outputs to xml file in rss format.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <justin@buzznet.com>
#      COMPANY:  Buzznet, Inc.
#      VERSION:  1.0
#      CREATED:  04/09/2008 07:19:46 PM PDT
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use XML::RSS;

my $file = '/var/www/virtual/adventures/buzznet.xml';
my $mode = 0;
my $data = {};

while (<>){
    print;
    /^$/ && $mode++;

    if ( $mode == 0 ){
        /^Subject: (.*)$/ && do { $data->{'subject'} = $1; };
        /^From: (.*)$/ && do { $data->{'from'} = $1; };
    }   else    {
        $data->{'message'} .= $_;
    }
}

my $rss = new XML::RSS;
$rss->parsefile($file);
pop(@{$rss->{'items'}}) if (@{$rss->{'items'}} == 17);
$rss->add_item(title => $data->{'subject'},
        link  => $data->{'from'},
        description => $data->{'message'},
        mode  => 'insert'
        );

$rss->save($file);




