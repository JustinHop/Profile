#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  naughty-fixer.pl
#
#        USAGE:  ./naughty-fixer.pl 
#
#  DESCRIPTION:  This runs at the same time as awesome. Monitors dbus for stuff
#  that naughty should be picking up. I am shit at lua. Giving up and going back
#  to perl.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  05/01/2009 12:21:02 PM PDT
#     REVISION:  $id$
#===============================================================================

#$SIG{'HUP'} = exec $0 or die $!;
#$SIG{'USR1'} = "signal";

use strict;
use warnings;
use HTML::Strip;

my $hs = HTML::Strip->new();

#  my $clean_text = $hs->parse( $raw_html );

my $icon = '';

if ( -e "/usr/share/icons/hicolor/48x48/apps/pidgin.png" ) {
    $icon = "/usr/share/icons/hicolor/48x48/apps/pidgin.png";
}

my $m = 0;
# mode var
# 0 = looking
# 1 = found pidgin revieved im

open( DBUS, "dbus-monitor |") || die $!;

my $user = "";

while(<DBUS>){
    if ( $m == 0 ) {
        # Looking for string
        if ( /interface=im.pidgin.purple.PurpleInterface; member=ReceivedImMsg/ ) {
            print $_ . "\n";
            # Found string
            $m = 1;
            next;
        }
    } elsif ( $m == 1 ) {
        if ( /string "(.*)"/ ) {
            my $string = $hs->parse( $1 );
#            $string =~ s/</&lt;/g;
#            $string =~ s/>/&gt;/g;
#            $string =~ s/'/%'/g;
            $hs->eof;
            if ( $user =~ /^$/ ) {
                $user = $string;
                next;
            } else {
                if ( -e "/usr/share/icons/hicolor/48x48/apps/pidgin.png" ) {
                    $icon = "/usr/share/icons/hicolor/48x48/apps/pidgin.png";
                }
                notify($user,substr ($string, 0, 250), $icon);
                $user = "";
                $icon = "";
                $m = 0;
                next;
            }
        }
    }
}

sub notify {
    my ($title,$message,$icon) = @_;
    open( AWESOME, "| tee /dev/stderr | awesome-client") or die $!; 
    print AWESOME "for i = 1, screen.count() " . 
        " do naughty.notify({title = \"$title\", border=5," .
        " icon=\"$icon\", screen = i, text=\'$message\', " . 
        " timeout = 5}) end\n";
    close AWESOME;
    sleep 1;
}

sub notifyper {
    my ($class,$title,$message,$icon) = @_;
    open( AWESOME, "| tee /dev/stderr | awesome-client") or die $!; 
    print AWESOME "for i = 1, screen.count() " . 
        " do notifys.$class.[i] = naughty.notify({title = \"$title\"," .
        " icon=\"$icon\", screen = i, text=\'escape($message)\', " . 
        " timeout = 5 , replaces_id=notifys.$class.[i].id}) end\n";
    close AWESOME;
    sleep 1;
}

my $mixer;
sub signal {
    print "Executing on signal USR1\n";
    my $aumix = `aumix -q | head -n 2`;
    if ( $mixer !~ /$aumix/s ) { 
        $mixer = $aumix;
        if ( -e "/usr/share/icons/Rodent/48x48/apps/gnome-audio.png" ) {
            $icon = "/usr/share/icons/Rodent/48x48/apps/gnome-audio.png";
        } else {
            $icon = "audio"
        }
        notifyper("volume","Volume",$mixer,$icon);
        $icon="";
    }
}



return main();


# vi: set ts=4 sw=4 et:

