#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  check.pl
#
#        USAGE:  ./check.pl
#
#  DESCRIPTION:  This is a cgi script to check all the sites
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), Justin.Hoppensteadt@umgtemp.com
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  07/22/2009 04:39:08 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

my $debug = 1;

use CGI::Pretty qw/:standard/;
use Data::Dumper;
use DBI;

my $dbh = DBI->connect( "DBI:mysql:database=webcheck;host=localhost",
    "webcheck", "webcheck", { 'RaiseError' => 0 } );

my $sth;
my $query;
my $label = {};

if ( $#ARGV >= 0 ) {
    if ( $ARGV[0] =~ /label/i ) {

        #
        #   Label Queries
        #
        if ( $#ARGV == 1 ) {
            if ( $ARGV[1] =~ /^\d+$/ ) {
                $query =
                  "SELECT label_name FROM label WHERE label_id = $ARGV[1]";
            } elsif ( $ARGV[1] =~ /^\w+$/ ) {
                $query =
                  "SELECT label_id FROM label WHERE label_name = $ARGV[1]";
            } else {
                bad();
            }
        } elsif ( $#ARGV == 0 ) {
            $query = "SELECT * FROM label";
        } else {
            bad();
        }
        query();
    } elsif ( $ARGV[0] =~ /system/i ) {
        #
        # Systems querys
        #
        if ( $#ARGV == 1 ) {
            if ( $ARGV[1] =~ /^\d+$/ ) {
                $query = "SELECT * FROM system WHERE label_id = $ARGV[1]";
            } else {
                bad();
            }
        } else {
            bad();
        }
        query();
    } elsif ( $ARGV[0] =~ /url/i ) {
        if ( $#ARGV == 0 ) {
            $query = "SELECT * FROM url";
        } elsif ( $#ARGV >= 1 ) {
            if ( $ARGV[1] =~ /^\d+$/ ) {
                if ( $#ARGV == 2 ) {
                    if ( $ARGV[2] =~ /^(?:http...)?((\w|\.)+)$/ ){
                        my $url = $1;
                        $query =
                            "INSERT url SET url = \"$url\", label_id = $ARGV[1]";
                    } else {
                        print $ARGV[2]. "\n";
                        die $@;
                    }
                } else {
                    $query = "SELECT * FROM url WHERE label_id = $ARGV[1]";
                } 
            } else {
                die $@;
            }
        } else {
            die $@;
        }
    } else {
        die $@;
    }
    query();
}else {
    die $@;
}




sub query {
  my $sth = $dbh->prepare($query);
  $sth->execute();

  if ($query =~ /select/i){
      while ( my $ref = $sth->fetchrow_arrayref() ) {
          for ( @{$ref} ) {
              print $_ . ":";
          }
          print "\n";
      }
      $sth->finish();
  }
}

sub bad {
  warn "BAD!";
  die $@;
}

# Disconnect from the database.
$dbh->disconnect();

