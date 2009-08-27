#!/usr/bin/perl -w
# Copyright (C) 2003 Paul T. Jobson
# pjobson@visual-e.net
# aim: vbrtrmn
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# The GNU General Public License is available here:
# http://www.gnu.org/copyleft/gpl.html#SEC3
##################################################################
# digger.cgi
# Program for doing recursive dig requests, used to find DNS
# propagation issues.

$| = 1;

use strict;
use CGI qw(:all);
use CGI::Carp('fatalsToBrowser');

my ($digdata,@NSlist,$nextlevel,$hostin,$gtld);
my $pass = param('password');
my $host = param('host');
push(@NSlist,param('gtld'));
my $sent = "false";

&doHTMLStart;
&checkforErrors;
&startDigLoop;
&doHTMLEnd;


sub startDigLoop {
        print "<center>Attempting to Query $host at every Name Server in the returned Zone Files.\nThis may take a minute or so.</center><hr>";
        for (@NSlist) {
                $gtld = $_;
                &doTheDig;
        }
}

sub doTheDig {
        $digdata = `dig \@$gtld $host any`;
        &outputData;
        &extractNS;
}

sub checkforErrors {
        if ($pass eq "") {
                &doHTMLEnd;
                exit;
        } elsif (0) {
                &invalidPasswordExit;
        } elsif ($host eq "") {
                print "<h1>Missing Host</h1>";
                exit;
        } elsif ($host =~ m/[\|&\+=\@%]/gi) {
                print "<h1>Invalid Host</h1>";
                exit;
        } elsif ($#NSlist < 0) {
                print "<h1>No gTLD Servers Selected</h1>";
                exit;
        }
        foreach (@NSlist) {
                if ($_ =~ m/[\|&\+=\@%]/gi) {
                        print "<h1>Invalid gTLD Server</h1>";
                        exit;
                }
        }

}

sub outputData {
        my $header = "<h2># dig \@<font color=red>$gtld</font> <font color=green>$host</font> any</h2>\n";
        if ($digdata =~ /(status: QUERY REFUSED)/) {
                print "$header $1<hr>";
        } elsif ($digdata =~ /(status: SERVER FAILED)/) {
                print "$header $1<hr>";
        } elsif ($digdata =~ /(status: CONNECTION REFUSED)/) {
                print "$header $1<hr>";
        } elsif ($digdata =~ /(status: TIMED OUT)/) {
                print "$header $1<hr>";
        } elsif ($digdata =~ /(status: NXDOMAIN)/) {
                print "$header $1<hr>";
        } elsif ($digdata =~ /(status: REFUSED)/) {
                print "$header $1<hr>";
        } elsif ($digdata =~ /(status: SERVFAIL)/) {
                print "$header $1<hr>";
        } elsif ($digdata =~ /status: NOERROR/) {
                print "$header";
                $digdata =~ s/$host/<font style="background-color: #FFFFbb;">$host<\/font>/g;
                print $digdata;
                print "<hr>";
        } else {
                print "$header unknown error code, probably invalid name server or server time-out; try resubmitting query.<HR>";
        }
}

sub extractNS {
        my @templist = $digdata =~ m/(NS\s+.+\.\n)/g;
        @templist = map { s/NS\s+(.+)\.\n/$1/; $_; } @templist; # clean the array
        for (@templist) {
                my $ns = lc($_);
                unless("@NSlist" =~ /$ns/) {
                        push(@NSlist, $ns);
                }
        }
}

sub invalidPasswordExit {
        print "<h1>Invalid Password</h1>";
        exit;
}

sub doHTMLStart {
        print header();
        print <<HTMLSTART;
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
        <HTML>
        <HEAD>
        <TITLE>&#252;ber dig tool</TITLE>
        <script type="text/javascript">
                function addHost() {
                        var host = prompt("Enter Host Name:");
                        var g = document.dig.gtld;
                        g.options[0].selected=0;
                        if (host.length>0) {
                                var x = g.options.length;
                                g.options[x] = new Option(host,host);
                                g.options[x].selected = 1;
                        }
                }
        </script>
        </HEAD>
        <BODY>
        <form name="dig" method="post" action="">
        <table border="0" cellspacing="0" cellpadding="2">
        <tr>
        <td>Password</td>
HTMLSTART
        print '<td><input name="password" type="password" id="password" value="'. ($pass ? $pass : '') .'"></td>';
        print <<HTMLSTART;
        </tr>
        <tr>
        <td>Host to Dig</td>
HTMLSTART

        print '<td><input name="host" type="text" value="'. ($host ? $host : '') .'"></td>';

        print <<HTMLSTART;
        </tr>
        <tr>
        <td valign="top">Starting Server</td>
        <td><select name="gtld" size="7" multiple="1">
<!--    <option value="" onclick="addHost();">User Defined</option> -->
        <optgroup label="GTLD Servers">
                <option value="a.gtld-servers.net">a.gtld-servers.net</option>
                <option value="b.gtld-servers.net">b.gtld-servers.net</option>
                <option value="c.gtld-servers.net">c.gtld-servers.net</option>
                <option value="d.gtld-servers.net">d.gtld-servers.net</option>
                <option value="e.gtld-servers.net">e.gtld-servers.net</option>
                <option value="f.gtld-servers.net">f.gtld-servers.net</option>
                <option value="g.gtld-servers.net">g.gtld-servers.net</option>
                <option value="h.gtld-servers.net">h.gtld-servers.net</option>
                <option value="i.gtld-servers.net">i.gtld-servers.net</option>
                <option value="j.gtld-servers.net">j.gtld-servers.net</option>
                <option value="k.gtld-servers.net">k.gtld-servers.net</option>
                <option value="l.gtld-servers.net">l.gtld-servers.net</option>
                <option value="m.gtld-servers.net">m.gtld-servers.net</option>
        </optgroup>
        <optgroup label="Root Servers">
                <option value="a.root-servers.net">a.root-servers.net</option>
                <option value="b.root-servers.net">b.root-servers.net</option>
                <option value="c.root-servers.net">c.root-servers.net</option>
                <option value="d.root-servers.net">d.root-servers.net</option>
                <option value="e.root-servers.net">e.root-servers.net</option>
                <option value="f.root-servers.net">f.root-servers.net</option>
                <option value="g.root-servers.net">g.root-servers.net</option>
                <option value="h.root-servers.net">h.root-servers.net</option>
                <option value="i.root-servers.net">i.root-servers.net</option>
                <option value="j.root-servers.net">j.root-servers.net</option>
                <option value="k.root-servers.net">k.root-servers.net</option>
                <option value="l.root-servers.net">l.root-servers.net</option>
                <option value="m.root-servers.net">m.root-servers.net</option>
        </optgroup>
        </select></td>
        </tr>
        <tr>
        <td>&nbsp; <!-- <input name="password" type="hidden" id="password" value="digger">  --></td>
        <td><input type="submit" name="Submit" value="QUERY"></td>
        </tr>
        </table>
        </form>
        <HR>
        <PRE>
HTMLSTART
}

sub doHTMLEnd {
        print <<HTMLEND;
        </PRE>
        </BODY>
        </HTML>
HTMLEND
}
