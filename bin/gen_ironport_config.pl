#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  gen_ironport_config.pl
#
#        USAGE:  ./gen_ironport_config.pl 
#
#  DESCRIPTION:  feed this a file in format
#               externalip  internalip   name     whatever
#
#               get ironport config xml
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  03/06/2009 06:59:56 PM PST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

while (<>){
    if ( /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+           # first ipaddress
            (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+         # sec ip
            (\w+\.(?:music|my)reg\.net)                     # the name
         /x
       ){
        my $in = $1;
        my $out = $2;
        my $name = $3;

#        print 
#            "    <interface>\n" .
#            "      <interface_name>$name</interface_name>\n" .
#            "      <ip>$in</ip>\n" .
#            "      <phys_interface>Data 1</phys_interface>\n" .
#            "      <netmask>255.255.255.0</netmask>\n" .
#            "      <interface_hostname>$name</interface_hostname>\n" .
#            "      <euq_base_url></euq_base_url>\n" .
#            "    </interface>\n";

        print
            "    <altsrchost_entry>\n" .
            "      <altsrchost_address>\@.$name</altsrchost_address>\n" .
            "      <interface_name>$name</interface_name>\n" .
            "    </altsrchost_entry>\n";



    }else{
        # warn "Line not good";
    }
}


