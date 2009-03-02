#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  mail.pl
#
#        USAGE:  ./mail.pl 
#
#  DESCRIPTION:  This will send mime encapsulated messages.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <justin@buzznet.com>
#      COMPANY:  Buzznet, Inc.
#      VERSION:  1.0
#      CREATED:  02/12/2009 08:58:46 PM GMT
#     REVISION:  $id$
#===============================================================================

use strict;
use warnings;

use MIME::Lite;

my $usage = "Usage: $0 zone (music|my) mx\n";

my $debug = 1;
my $zone;
my $dom = "musicreg.net";
my $domnot = "myreg.net";
my $mx = "ukromlsmx01.internal.musicreg.net";
my $dns = 1;

if ( exists $ARGV[0] && $ARGV[0] =~ /^\w+$/ ){
    if ($ARGV[0] =~ /^nodns$/ ){
    	$dns = 0;
    	shift @ARGV;
    }
    $zone = $ARGV[0];
}   else    {
    die $usage;
}

if ( exists $ARGV[1] ){
    if ( $ARGV[1] =~ /^(?:music|my)/ ){
        if ( $ARGV[1] =~ /^my/ ) {
            $dom = "myreg.net";
            $domnot = "musicreg.net";
        }
    }   else    {
        die $usage;
    }
}
    
if ( exists $ARGV[2] ){
    my ($cont,$num);
    if ( $ARGV[2] =~ /^(us|uk)\w+(\d)$/i ) {
        $cont = $1;
        $num = $2;
        if ($cont =~ /^us$/){
            $mx = "usfshlxmx0$num.internal.myreg.net";
        }
    }
}

my @TO = ( 'test@justinhoppensteadt.com', );
my $FROM = "testemailfrom_$zone\@$zone.$dom";
my $SUBJECT = "$zone.$dom from $mx";
my $TYPE = 'multipart/mixed';

my $MAILCMD = "/usr/local/bin/qmail-remote $mx bounce\@pobox.$zone.$dom ";

my $MESSAGE = "\n"  .
    "Test Message From $zone.$dom\n" .
    "Sent: " . `date` . 
    "Sent using: $0 " . join(" ",@ARGV) . "\n" .
    "Sent To: " . join(" ",@TO) . "\n"
    ;

my $DNS = "DNS TEST DISABLED\n\n";
if ( $dns == 1 ){
    print "Doing DNS Check\n";
    $DNS = `ecrm_dns_test.pl $zone`;
    print "Finsihed, mailing\n";
}

foreach my $to (@TO){
    open ( SEND, " | $MAILCMD $to" );
    my $msg = MIME::Lite->new(
        From    =>  $FROM,
        To      =>  $to,
        Subject =>  $SUBJECT,
        Type    =>  $TYPE,
    );
    $msg->attach(
        Type    =>  'text/plain',
        Data    =>  $MESSAGE,
    );
    $msg->attach(
        Type    =>  'text/plain',
        Data    =>  $DNS,
    );
    $msg->print(\*SEND);
    close SEND;
}


