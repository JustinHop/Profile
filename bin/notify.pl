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

my $n = $notify->create(summary => 'Desktop::Notify',
        # body => join(" ", @ARGC),
        body    =>  "Hello!",
        timeout =>  2000,);

$n->show();


# vi: set ts=4 sw=4 et:

