#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  db2csv-weed.pl
#
#        USAGE:  ./db2csv-weed.pl  
#
#  DESCRIPTION:  db to csv
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  09/19/2009 07:08:48 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use DBI;

my $database = 'laweedmap';
my $hostname = 'localhost';
my $dsn      = "DBI:mysql:database=$database;host=$hostname";

my $user = "foo";
my $password = "bar";

my $dbh = DBI->connect( $dsn, $user, $password );

my $sth = $dbh->prepare(qq{
        SELECT 
            name, address1, phone, hours
        FROM
            ca
});
$sth->execute;

my @order = qw{ address1 phone hours };

while (my $h = $sth->fetchrow_hashref) {
    print '<b>' . $h->{'name'} . '</b>' . "\t" . $h->{'address1'} . "\t";

    for (@order) {
        print $h->{$_} . "<br />";
    }

    print "\n";
    
}

