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
use CGI::Pretty qw/:standard/;
use Data::Dumper;
use Mojo::URL;
use Socket;

my $debug = 1;

my $a = {};
my @good;
my @bad;

while (<STDIN>) {
    if (/^(.*)\.dns:(\S+).*(\d+\.\d+\.\d+\.\d+)/) {
            my $s;
            my $r;
        my $q             = {};
        my $good          = 1;
        my $umg_responce  = "";
        my $real_responce = "";
        my $mismatch      = 0;
        my $base          = $1;
        my $host          = $2;
        my $ip            = "16" . $3;
        if ( $host =~ /@/ ) {
            $host = $base;
        } else {
            $host = $host . "." . $base;
        }
        $q->{'host'}   = $host;
        $q->{'umg_ip'} = $ip;
        print $host . "\n";
        open( NSLOOK, "nslookup $host 208.67.222.222 |" );
        my $open_ip;
        while (<NSLOOK>) {
            if (/Address: (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/i) {
                $open_ip = $1;
                $q->{'open_ip'} = $open_ip;
            }
        }
        if (
            0

# $host =~
#/(def(jam|soul)|maadcircle|umusic|tjmartell|(www2|eteam).thrice|stolentran|losernation|(eteam|ww6).mar|kenny|ww7|dietrying|ns5|splash|asp.mot|\.roca|website|monarc)/
          )
        {

            #            #print " Problematic URL\n";
            $umg_responce = "Problematic URL";
        } else {
            if ( $open_ip =~ /0.0.0.0/ ) {
                next;
            }
            if (
                $s = Net::HTTP->new(
                    Host    => $host,
                    Timeout => "5",
                )
              )
            {
                $s->write_request( GET => "/", 'User-Agent' => "Mozilla/5.0" )
                  && do {
                    my ( $code, $mess, %headers ) = ("", "", {}); 
                    ( $code, $mess, %headers ) = $s->read_response_headers(laxed=> 1) || next;
                    $umg_responce = "$code : $mess";
                    if (   ( $code =~ /^3\d\d/ )
                        && ( exists $headers{"Location"} ) )
                    {
                        $umg_responce =
                          "$code : $mess => " . $headers{"Location"};
                    }
                    $q->{'umg_responce'} = $umg_responce;
                    print $umg_responce . "\n";
                  };
            }
            if ( $ip !~ $open_ip ) {
                $mismatch++;
                if (
                    $r = Net::HTTP->new(
                        Host     => $host,
                        PeerAddr => $open_ip,
                        Timeout  => "5",
                    )
                  )
                {
                    $r->write_request(
                        GET          => "/",
                        'User-Agent' => "Mozilla/5.0"
                      )
                      && do {
                        my ( $rcode, $rmess, %rheaders ) = ("", "", {}); 
                        ( $rcode, $rmess, %rheaders ) =
                          $r->read_response_headers(laxed => 1) || next;
                        $real_responce = "$rcode : $rmess";
                        if (   ( $rcode =~ /^3\d\d/ )
                            && ( exists $rheaders{"Location"} ) )
                        {
                            $real_responce =
                              "$rcode : $rmess => " . $rheaders{"Location"};
                        }
                        $q->{'real_responce'} = $real_responce;
                        print $real_responce . "\n";
                      };
                }
                push( @bad, $q );
            } else {
                push( @good, $q );
            }
        }
    }
}

my $foo = {
    good => \@good,
    bad  => \@bad,
};

print header, start_html('Output'), h1('Good Ones (DNS)');

print "<table border=1>\n";
print "<tr><td>Host<td>UMG IP<td>OPENDNS IP<td>HTML RESPONCE</tr>\n";

for my $out (@good) {
    print "<tr><td>"
      . $out->{'host'} . "<td>"
      . $out->{'umg_ip'} . "<td>"
      . $out->{'open_ip'} . "<td>"
      . $out->{'umg_responce'}
      . "</tr>\n";
}

print "</table><br>\n\n\n\n";

print h2('Bad Ones (DNS)');
print "<table border=1>\n";

print
"<tr><td>Host<td>UMG IP<td>OPENDNS IP<td>UMG HTML RESPONCE<td>INTERNET HTML RESPONCE</tr>\n";

for my $out (@bad) {
    print "<tr><td>"
      . $out->{'host'} . "<td>"
      . $out->{'umg_ip'} . "<td>"
      . $out->{'open_ip'} . "<td>"
      . $out->{'umg_responce'} . "<td>"
      . $out->{'real_responce'}
      . "</tr>\n";
}

print "</table><br>\n\n\n\n";

#print Dumper($foo);

sub check {
    my ($url) = Mojo::URL->new("http://$_") || return;
    if ( $url->host ) {

        #        print "Testing : " . $_ . "\n";
    } else {

        #        print "Bad : $_\n" if $debug;
    }
    for my $hostaddr (@ARGV) {

        #        print "\t$hostaddr = ";
        my $s = Net::HTTP->new(
            PeerAddr => $hostaddr,
            Host     => $url->host,
        ) || next;
        $s->write_request(
            GET          => $url->path,
            'User-Agent' => "Mozilla/5.0"
        );
        my ( $code, $mess, %headers ) = $s->read_response_headers();

        #        print $code . " \"" . $mess . " \"  ";
        if ( ( $code =~ /^3\d\d/ ) && ( exists $headers{"Location"} ) ) {

            #            print " = " . $headers{"Location"} . "\n";
        }
    }
    return;
}    # ----------  end of subroutine check  ----------

sub help {

    #    print "$0: [host] ..[ (host.. host)] < file_containing_hostnames\n";
    die "User error: $!";
}

