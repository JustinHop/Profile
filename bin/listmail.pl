#!/usr/bin/perl -w
#===============================================================================
#
#         FILE:  listmail.pl
#
#        USAGE:  ./listmail.pl 
#
#  DESCRIPTION:  List all my email
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  02/27/2009 06:34:33 AM PST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Email::Simple;
use Email::Folder;
use Email::Folder::Exchange;

my $folder = Email::Folder::Exchange->new('https://mail.umusic.com/exchange/HoppenJ/', 'GLOBAL\HoppenJ', 'Music2009' );

for my $message ($folder->messages){
    print "subject: " . $message->header('Subject');
}

for my $folder ($folder->folders){
    print "folder uri: " . $folder->uri->as_string .
        " contains " . scalar($folder->messages) . " messages" .
        " and " . scalar($folder->folders) . "folders\n";
}


