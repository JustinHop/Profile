#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  toptalk.pl
#
#        USAGE:  ./toptalk.pl 
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <justin@buzznet.com>
#      COMPANY:  Buzznet, Inc.
#      VERSION:  1.0
#      CREATED:  04/11/08 17:33:15 PDT
#     REVISION:  ---
#===============================================================================

use Getopt::Long;

my $clear, $interval = 5, $num = 10, $proto;

GetOptions ("interval=i" => \$interval,
            "num=i"=> \$num,
            "clear" => \$clear,
            "proto" => \$proto,
            'help|?' => sub {usage(); exit;});    # numeric


my $ipHash = {};

my $tm = time();

my $expr = join(" ", @ARGV);

if(undef and !$expr) {
        print STDERR "You MUST supply a tcpdump filter expression!\n";
        usage();
        exit;
}

my $startTime = time();

die "Can't read from tcpdump: ^E\n"
        unless open(TCPDUMP, "tcpdump -n '$expr'|");

while(<TCPDUMP>) {

        my ($time,$proto,$src,$mark,$dest,$flags,$junk) = split;

        my ($srcIP) = ($src =~ /((?:[0-9]{1,3}\.){3}(?:[0-9]{1,3}))/);

        if($proto) {
                my ($p) = ($dest =~ /.*\.(.*)\:$/);
                $srcIP.="-".$p;
        }

        $ipHash->{$srcIP}++;

        if((time() - $tm) >= $interval) {
                dumpHash($ipHash);
                $tm = time();
        }
}

sub usage {
        print "\n$0 [--interval=INTERVAL] [--num=TOP X HOSTS] [--proto]
[--clear] <expr>\n\n";
}


sub dumpHash {
        my $hash = shift;

        my $count = 0;

        if($clear) {
                print `tput clear`;
        }

        print "--- Top packets matching [$expr]\n";
        print "--- From ".localtime($startTime)." through
".localtime()."\n";

        foreach $ip (sort { $hash->{$b} <=> $hash->{$a} }  keys %$hash) {
                printf("%-20s %10d\n", $ip, $hash->{$ip});
                if($count++ >= $num) {
                        last;
                }
        }
}


