#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  notify.pl
#
#        USAGE:  ./notify.pl 
#
#  DESCRIPTION:  notify me of something
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  03/18/2009 12:49:13 AM PDT
#     REVISION:  $id$
#===============================================================================

use strict;
use warnings;

use Desktop::Notify;

my $notify = Desktop::Notify->new();

my $title = 'Desktop::Notify';

 $title = $ARGV[0] if  $ARGV[0];

my $body = 'Hello!';

 $body = $ARGV[1] if ( $ARGV[1] );

my $timeout = 2000;

 $timeout = $ARGV[2] if ( $ARGV[2] );

my $n = $notify->create(summary => $title ,
        # body => join(" ", @ARGC),
        body    =>  $body,
        timeout =>  $timeout,);

$n->show();


# vi: set ts=4 sw=4 et:

