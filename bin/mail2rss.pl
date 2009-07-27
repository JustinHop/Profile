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
use Unicode::String qw(utf8 latin1 utf16);

my $file = '/var/www/virtual/adventures/buzznet.xml';
my $ext = `date | md5sum | awk ' {print \$1 }'`;
chomp $ext;
my $tmpfile = '/tmp/buzzxml.' . $ext;
my $mode = 0;
my $data = {};
my $lock = '/tmp/rss.lock';

sub do_exit {
    `rm -rf $lock`;
    die "Caught signal!";
}
$SIG{INT} = \&do_exit;

my $count = 0;
while ( -e $lock ){
    sleep 5;
    if ( $count++ > 10 ) {
        die "Timed out on lockfile";
    }
}

$count = 0;
while (<>){
    /^$/ && $mode++;
    my $line = $_;
    my $u = Unicode::String::latin1($line);
    $line = $u->utf8;
    print $line;

    if ( $mode == 0 ){
        $line =~ /^Subject: (.*)$/ && do { $data->{'subject'} = $1; };
        $line =~ /^From: (.*)$/ && do { $data->{'from'} = $1; };
    }   else    {
        if ( $count++ <= 100 ) {
            $data->{'message'} .= $line;
        }
    }
}

open( OLDFILE, "<", $file );
open( NEWFILE, ">", $tmpfile );

while (<OLDFILE>){
    if ( m!</c! ) {
        last;
    }   else    {
        print NEWFILE;
    }
}
print NEWFILE "</channel>\n</rss>\n";

close NEWFILE;
close OLDFILE;

my $rss = new XML::RSS;
$rss->parsefile($tmpfile);
#pop(@{$rss->{'items'}}) if (@{$rss->{'items'}} == 25);
pop(@{$rss->{'items'}}) while (@{$rss->{'items'}} >= 25);
$rss->add_item(title => $data->{'subject'},
        link  => $data->{'from'},
        description => $data->{'message'},
        mode  => 'insert'
        );

$rss->save($file);

`rm -rf $lock $tmpfile`;

