#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  backup.pl
#
#        USAGE:  ./backup.pl 
#
#  DESCRIPTION:  Simple backup script.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <jhoppensteadt@valueclick.com>
#      COMPANY:  Value Click, Inc.
#      VERSION:  1.0
#      CREATED:  11/08/2007 06:41:33 PM PST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

my $DIR="$ENV{HOME}/backup";
my $DATE=`date +%F`;
chomp $DATE;
my $HOST=`hostname`;
chomp $HOST;
my $COUNT=0001;

if ( ! -d $DIR ){
    mkdir $DIR || die "Can not create $DIR";
}

foreach my $FILE (@ARGV){
    my $LS; my $NUMBER;

    if ( -e "$DIR/$FILE\:$HOST\:$DATE\:0001" ) {

        $LS = `/bin/ls $DIR/$FILE\:$HOST\:$DATE\:* | tail -1 2>/dev/null`;
        chomp $LS;
    
        $LS =~ /.*(\d\d\d\d)$/;
        
        if ( $1 ) {
            $NUMBER = $1 + 1;
        } 
    } else {
        $NUMBER = 1;
    }
    
    $COUNT=sprintf("%04d", $NUMBER );

    #print "Backing up $FILE to $DIR/$FILE\:$HOST\:$DATE\:$COUNT" . "\n";
    print `cp -av $FILE \"$DIR/$FILE\:$HOST\:$DATE\:$COUNT\"`; 
        
}

