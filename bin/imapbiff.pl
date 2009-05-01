#!/usr/bin/perl
# $Id: imapbiff.pl,v 1.8 2008/04/01 01:13:14 jcs Exp $
#
# imap biff with meow/growl/dbus notification
#
# Copyright (c) 2006, 2008 joshua stein <jcs@jcs.org>
# ssl work-around code from Nick Burch (http://gagravarr.org/code/)
# modified to work with awesome naughty by Justin Hoppensteadt
# <awesome@justinhoppensteadt.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 

#
# to configure, re-define variables in a ~/.imapbiffrc file like so:
#
#	%config = (
#		"server.name.here" => {
#			"username" => "example",
#			"password" => "password",
#			"ssl" => 1,
#			"folders" => [ "INBOX", "mailbox2", "mailbox3.whatever" ],
#		},
#		"server2" => {
#			"username" => "example",
#			... more config ...
#		},
#	);
#
#	# seconds between folder polls
#	$sleepint = 60;
#
#	# for verbosity
#	#$debug = 1;
#
#	# which notification mechanism to use ("meow", "dbus", or "growl")
#	$notify = "dbus";
#

use strict;
use Fcntl;
use IO::Socket::SSL;
use Mail::IMAPClient;
use MIME::Base64;
use MIME::QuotedPrint;

my (%config, $debug, $notify, $icon, $sleepint, $socktimeout);
our ($dbus, $dbus_service, $dbus_notification);

# default seconds to sleep between check intervals
$sleepint = 60;

# seconds to allow a folder check to take
$socktimeout = 10;

# use dbus notifications by default
$notify = "dbus";

# read the user's config
my $configdat;
open(C, $ENV{"HOME"} . "/.imapbiffrc") or
	die "no config file in ~/.imapbiffrc";
while (my $line = <C>) {
	$configdat .= $line;
}
close(C);

eval($configdat) or die "invalid configuration file, exiting\n";

# check for bogus config
if ($notify != "dbus" || $notify != "meow" || $notify != "growl") {
	die "unknown notification type \"" . $notify . "\"\n";
}

if ($notify eq "dbus") {
	use Net::DBus;

	$dbus = Net::DBus->find;
	$dbus_service = $dbus->get_service("org.freedesktop.Notifications");
	$dbus_notification = $dbus_service->get_object(
		"/org/freedesktop/Notifications", "org.freedesktop.Notifications");
}

# clean up nicely if we can
$SIG{"TERM"} = "die_signal_handler";
$SIG{"INT"} = "die_signal_handler";

# create tmp file with icon to pass to notifiers
$icon = write_icon();

# init, build connections
foreach my $server (keys %config) {
	foreach my $folder (@{$config{$server}{"folders"}}) {
		$config{$server}{"seen"}{$folder} = ();
	}

	imap_connect($server);
}

notify("imapbiff", "imapbiff started");

# run forever
for(;;) {
	SERVER: foreach my $server (keys %config) {
		my $imap = $config{$server}{"imap"};

		foreach my $folder (@{$config{$server}{"folders"}}) {
			eval {
				local $SIG{"ALRM"} = sub { die; };
				alarm($socktimeout);

				if ($debug) {
					print "checking " . $server . ":" . $folder . "\n";
				}

				$$imap->select($folder) or die;
				my @unseen = ($$imap->unseen);

				foreach my $newu (@unseen) {
					my $isold = 0;
					foreach my $curu (@{$config{$server}{"seen"}{$folder}}) {
						if ($newu eq $curu) {
							$isold = 1;
							last;
						}
					}

					if (!$isold) {
						announce_message($server, $folder, $newu);
					}
				}

				$config{$server}{"seen"}{$folder} = \@unseen;
			};

			alarm(0);

			if ($@) {
				# timed out, server may be dead, drop it and reconnect
				if ($debug) {
					print "server connection timed out: " . $@ . "\n";
				}

				if ($config{$server}{"init"}) {
					notify("imapbiff", "lost connection to server " . $server);
				}

				# throttle
				sleep $sleepint;

				imap_connect($server);

				# and retry
				redo SERVER;
			}
		}

		$config{$server}{"init"} = 1;
	}

	if ($debug) {
		print "sleeping for " . $sleepint . "\n";
	}

	sleep $sleepint;
}

exit;

sub imap_connect {
	my $server = $_[0];
	my ($sock, $imap);

	$config{$server}{"init"} = 0;

	if ($debug) {
		print "connecting to " . ($config{$server}{"ssl"} ? "ssl " : "")
			. "server " . $server . "\n";
	}

	if ($config{$server}{"ssl"}) {
		eval {
			$sock = new IO::Socket::SSL(
				PeerHost => $server,
				PeerPort => ($config{$server}{"port"} ?
					$config{$server}{"port"} : 993),
				Timeout => 5,
			) or die "no ssl socket: " . $@;

			$config{$server}{"sslsock"} = \$sock;
		};

		if ($@) {
			# connect failed, we'll try again later
			if ($debug) {
				print "connect failed (" . $@ . ")\n";
			}
			return;
		}
	}

	$imap = Mail::IMAPClient->new(
		Socket => ($config{$server}{"ssl"} ? ${$config{$server}{"sslsock"}}
			: undef),
		User => $config{$server}{"username"},
		Password => $config{$server}{"password"},
		Peek => 1,
		Debug => $debug,
	) or die "no imap connection: " . $@;

	$config{$server}{"imap"} = \$imap;

	if ($config{$server}{"ssl"}) {
		$imap->State(Mail::IMAPClient::Connected);

		# get the imap server to the point of accepting a login prompt
		my $retcode;
		until ($retcode) {
			my $d = $imap->_read_line or return undef;

			for my $line (@$d) {
				next unless $line->[Mail::IMAPClient::TYPE] eq "OUTPUT";

				($retcode) =
					$line->[Mail::IMAPClient::DATA] =~ /^\*\s+(OK|BAD|NO)/i;

				if ($retcode =~ /BYE|NO /) {
					die "imap server disconnected";
				}
			}
		}

		$imap->login or die "login failed to " . $server . ": " . $!;
	}

	if ($debug) {
		print "connected to " . ($config{$server}{"ssl"} ? "ssl " : "")
			. "server " . $server . "\n";
	}
}

sub announce_message {
	my ($server, $folder, $msgno) = @_;

	if (!$config{$server}{"init"}) {
		# this may be a lot of messages, be quiet
		return;
	}

	my $imap = $config{$server}{"imap"};

	if ($debug) {
		print "new message " . $msgno . " in folder " . $folder . " on "
			. $server . "\n";
	}

	my $subject = hsc(decode_qp($$imap->get_header($msgno, "Subject")));
	my $from = hsc(decode_qp($$imap->get_header($msgno, "From")));

	# strip high ascii because growlnotify likes to segfault on it
	$subject =~ tr/\000-\177//cd; 
	$from =~ tr/\000-\177//cd; 

    # Awesome Naughty does not strip non legal pango markup and just pass it
    # dumb
    # by me
    $from =~ s![^\\]<!\\<!g;
    $from =~ s![^\\]>!\\>!g;

	$folder =~ tr/[A-Z]/[a-z]/;

	if ($notify eq "growl") {
		notify($subject, "From: " . $from);
	}

	elsif ($notify eq "meow") {
		notify("New message in <b>" . $folder . "</b>\n"
			. "From <b>" . $from . "</b>:\n"
			. $subject);
	}

	elsif ($notify eq "dbus") {
		notify("[" . $folder . "] " . $subject, "From " . $from);
	}
}

sub notify {
	if ($notify eq "growlnotify") {
		system("/usr/local/bin/growlnotify",
			"-n", "imapbiff",
			"--image", $icon,
			"-t", $_[0],
			"-m", $_[1]);
	}

	elsif ($notify eq "meow") {
		sysopen(MEOW, ($ENV{"MEOW_SOCK"} ? $ENV{"MEOW_SOCK"}
			: $ENV{"HOME"} . "/.meow"), O_WRONLY|O_NONBLOCK) or
			die "can't write to meow socket (not running?)";

		print MEOW "||" . $_[0] . "\n";

		close(MEOW);
	}
	
	elsif ($notify eq "dbus") {
        if ($debug) {
            print "$0: imapbiff, 0, $icon, $_[0], $_[1], [], {}, -1\n"
        }
		$dbus_notification->Notify(
			"imapbiff",
			0,
			$icon,
			$_[0],
			$_[1],
			[],
			{},
			-1
		);
	}
}

sub hsc {
	my $text = $_[0];

	$text =~ s/&/&amp;/g;
	$text =~ s/</&lt;/g;
	$text =~ s/>/&gt;/g;

	return $text;
}

sub die_signal_handler {
	if ($debug) {
		print "got deadly signal, deleting " . $icon . "\n";
	}

	unlink($icon);

	exit;
}

sub write_icon {
	chop(my $tmp = `mktemp /tmp/imapbiff.XXXXXX`);
	if (!$tmp) {
		die "can't make temp file: " . $1;
	}

	open(TMP, ">>" . $tmp) or die "can't write to temp file " . $tmp . ":"
		. $!;
	print TMP MIME::Base64::decode(
'iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAAZiS0dEAP8A
/wD/oL2nkwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9gCFREbBwUIV1EAAAUhSURBVFjD
7ZdpbFRVFMd/s3Zm2s5Gp2WmLUvbCKRYKFQImwUES2WLEQtfwDTsCUIgUTRiIjFxTQh+ElGMCUoM
ESzE1C2hRMACKaW2RSPttAKdIVJKZ6bLLG/evX4oVJAiQwt+8iQ3ee/lnv8573/+75z74H8bglVV
VZmGiqEdinNbUFn/7r6De4eCoRmMU01NzYhjv3hf1xtNL4xwpxu8rZc+3r52xbrb91RWViaFNClv
/HZ61ms7d2rEQ2Wgptm32mazl29a/ozh2TlTyBmVvfbtj77oZ6LiWPWWan/kakdEvDJ74fm5D42B
s2cbss81t27QGozlS+dMcXf1amm+HGTuE8OpqDpDVyj0bUdMjsjJysxfPGMCnd297K880Th3TPrM
oqKi4ECY+gdKoMm7yWxJfnl2UQHetijfnLhCTBFoiWO2WAgolJaXFOGymqn1waTMFEZnZoz3BaLl
wO5BM3Dw4EFjty5layisvPj8/BmZvREdn1d66Q7HycpQiWpCLJxWyPhRGbQG4euqMN2h65TOyCY/
S+H9A5WdSwtHPl5YWOh7YAZqa2tdP9T+/pbFItYsmzedNHsq4WgcW6qKNuk64x7LoaRoOgA3orC/
4gqxaA9JphSOn2sne5iL4onjHA0+3w5g4wOLsK7l6kqj0bxi1aJiXA4rgWAXR06eIz1dsmnZXEqK
xvXvTTWAzaJiTrYTj0W4dvUSFy93MbMgj6uh6IYTp2snJFyC6vPnR52u926WGn35yoXFdnOSkVP1
F/m1rZ2SqRMZN8LVvzfUE0an05GUZMTri/LJoQbMJh1PT8tm8lg7UkoaWnz8XHfh+yx975KysrLY
fUtQ09i60Wa1bV00azKt/mtUVDfyZOFYVi+eTarJgAqoErq6euns7EAIgcPhxGqKM63AxaxJaWg1
0BuJApDrSaO60Viid9hLgSP/ysCeA0d3xKRcP71gTNaP55vwpKcxe+IY7A47QgiEEKiqihCCcDhM
T3c3qhrHbneg1f5dVSnlHbjtgS4OHTvTPHG0dWrZggU37slAOBZ902ixcrzxD56aOoHhzj7gQLC7
LwEp+sClRAiBVm9AbzQRVVSkjN9TTylmE1kZaXkdoega4L27GNj12WH5Xw2yLGfqyLIl8y/3M/DO
p4dfdWeksWLBrEce/MvvTlLX3PYhsFAP8NIH+ysxmEoVVSIl+Hw+/H4/ubm5eL1enE4nubm5gwr2
3PaG/mt7Rj77tmlRVEFEUVL6NWAzG4929YbnxW3JBiklUkpycnKQUuJ2u9FoNHcJKlGzZ+TfcS+l
JC5g17ZVxf2NaMe65XtudN6oVgQIKXF7PNgdDuwOB26Ph+FuN0LKQa3Anxf6F/ThK2KAVuy2JW2O
S02dkOD3+TCZzQC0tHjxuD2YzGacTueQGRASVDFwJ9Ts/uonsX7J9Ecuwr1HT7FlWbHmn31AKkIi
xf1r3dTURLrLhd5gwO/3k5xsAcDjyUwogZjQDDwNYyqoCYgtJy9vwGs1QaHGVDlwAoogIbUHgwEU
RSHQGcCV7uJ6+3Vy8/Lo7enBkpx8X39F3CuBuERNoASqkEQiMUxmCx0dnTiGDSMSjaGKxPxj6j0O
JDGZ2PdutdqwWm13Pb/VQ+7PwN0a0AC6uCoRQ5gGOr0hIf94nwYMQFx/28nIEmfwHe9BLN7X/yxA
j/7m2+sB84X6OpbX1/1XA9ECRDQ3EzACNiAF0A32jylBk4AK9ADBW4F0N5N41MHvrATE/gLYd1mH
8lBaPAAAAABJRU5ErkJggg=='
	);
	close(TMP);

	return $tmp;
}
