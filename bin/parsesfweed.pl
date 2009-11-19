#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  parseweed.pl
#
#        USAGE:  ./parseweed.pl
#
#  DESCRIPTION:  This program will parse html and give me fields for la weed map
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  09/19/2009 03:25:19 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use HTML::TreeBuilder;
use HTML::Strip;
use DBI;
use Data::Dumper;

#my $database = 'laweedmap';
#my $hostname = 'localhost';
#my $dsn      = "DBI:mysql:database=$database;host=$hostname";

my $user = "foo";
my $password = "bar";

#my $dbh = DBI->connect( $dsn, $user, $password );

#my $sth = $dbh->prepare(qq{INSERT INTO ca (name, address1, phone, hours) VALUES (?, ?, ?, ?)});

my $hs = HTML::Strip->new();

for (@ARGV) {

    #print $_ . "\n";
    if ( -f $_ ) {
        my $root = HTML::TreeBuilder->new_from_file($_);
        $root->elementify();
        my @tables = $root->look_down( "_tag", "td" );

        for (@tables) {
            print $_->as_text() . "\n";
        }

    }
}


__END__
#        my $name = $tables[1]->look_down( "_tag", "strong" );
#        my $info = $tables[1]->look_down( "_tag", "span" );
#
#        my $info_text = $info->as_text();
#        my $info_html = $info->as_HTML();
#        my $info_xml  = $info->as_XML();
#
#        my $info_sed = $info_xml;
#        $info_sed =~ s!<br />! \n !g;
#
#        my @seds = split( "\n", $info_sed );
#        my @cleans;
#
#        for (@seds) {
#            my $clean = $hs->parse($_);
#            push @cleans, $clean;
#        }

#        if ( $info_text =~ /Co-Op/ ) {
#            $root->delete;
#            next;
#        } else {
#            my @infos;
#
##if ( $info_text =~ /^(.*)Phone: (.*\d\d\d\d( \d{3}-\(\D{4}\))?).*Fax: (.*\d\d\d\d) .*Hours: (.*) Map:/ ) {
##    @infos = ( $1, $2, $3, $4 );
##} elsif ( $info_text =~ /^(.*)Hours: (.*) Phone: (.*\d\d\d\d( \d{3}-\(\D{4}\))?).*Fax: (.*\d\d\d\d) .*Map:/ ) {
##    @infos = ( $1, $2, $3, $4 );
##} elsif ( $info_text =~ /^(.*)Phone: (.*\d\d\d\d) .*Hours: (.*) Map:/ ) {
##    @infos = ( $1, $2, $3 );
##} elsif ( $info_text =~ /^(.*)Phone: (.*\d\d\d\d)/ ) {
##    @infos = ( $1, $2 );
##}
#
#            #$info_asline =~ s/(\w+:
#
#            #print $info_text . "\n";
#            #print $info_html . "\n";
#            #print $info_xml . "\n";
#            #print $info_sed . "\n";
#
#            my $info = {};
#
#            $info->{'address'} = $cleans[0];
#            chomp $info->{'address'};
#
#            $info->{'name'} = $name->as_text();
#            chomp $info->{'name'};
#
#            for (@cleans) {
#
#                #print $_ . "\n";
#                if (/^\s*(\w+):\s*(.*)$/) {
#                    my $key   = lc $1;
#                    my $value = $2;
#                    $value =~ s!,!`!g;
#                    $info->{$key} = $value;
#                }
#            }



