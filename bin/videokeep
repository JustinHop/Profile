#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  videokeep.pl
#
#        USAGE:  ./videokeep.pl
#
#  DESCRIPTION:  for sorting video mess
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  03/10/09 06:42:37 PDT
#     REVISION:  $id$
#===============================================================================

use strict;
use warnings;

use Term::ReadKey;
use Getopt::Std;
use File::Copy;
use String::ShellQuote;

my %arg;
getopts( 'dvtf', \%arg );

my $cmd = 'bash';

my @m = qw/ -fixed-vo -osd-duration 5 -af volume=-5\,volnorm -osdlevel 0/;
push ( @m, "-fs" ) if exists $arg{'f'};
my $M = q/ mplayer -fixed-vo -osd-duration 5 -af volume=-5,volnorm -osdlevel 0 /;
$M .= " -fs " if exists $arg{'f'};

for ( "keep", "nokeep" ) {
    print "$_\n" if exists $arg{'v'};
    if ( !-d $_ ) {
        mkdir( $_, '0755' ) || die "$!";
    }
}

for my $video (@ARGV) {
    chomp;
    my $shellvideo = $video;
    $shellvideo = quotemeta $video;
    my @player = ($cmd, $M, $video);
    my $play = $cmd . " -c \"" . $M . "'" . $video . "'\"";
    print "$play \n";
    my $new = $video;
    $new =~ s/ /_/g;
    $new = lc $new;
    my $key = 'n';
    print "Running for $video\n" . "Would change to $new\n"
      if exists $arg{'v'};
    if ( -e $video ) {
        for (@player){
           print "$_ :\t";
        } print "\n";
        `$play`  unless exists $arg{'t'};
        #`mplayer $OPS "$video"` unless exists $arg{'t'};
        print "$video : Hit y to move to keep/$new and n to nokeep/$new\n";
        $key = ReadKey(0);
        if ( $key =~ /^y$/i ) {
            print "Yes selected, moving $video to nokeep\n";
            if ( !-e "nokeep/$new" ) {
                do { move( $video, "nokeep/$new" ) || die $! }
                  unless exists $arg{'d'};
            }
        } elsif ( $key =~ /^n$/i ) {
            print "No selected, moving $video to keep\n";
            if ( !-e "keep/$new" ) {
                do { move( $video, "keep/$new" ) || die $! }
                  unless exists $arg{'d'};
            }
        } else {
            warn "$video does not exist";
        }
    }
}

# vi: set ts=4 sw=4 et:

