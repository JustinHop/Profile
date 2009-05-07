#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  amix.pl
#
#        USAGE:  ./amix.pl 
#
#  DESCRIPTION:  returns simple sound vals
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Justin Hoppensteadt (JH), <Justin.Hoppensteadt@umgtemp.com>
#      COMPANY:  Universal Music Group
#      VERSION:  1.0
#      CREATED:  05/06/09 08:09:51 PDT
#     REVISION:  $id$
#===============================================================================

use strict;
use warnings;

use Data::Dumper;

sub mix {
    my $vol = {};
    open (MIX, "amixer |");

    while(<MIX>){
        if ( /^Simple mixer control '([^']+)',0/ ){
            $vol->{'last'}= $1;
            next;
        }else{
            if (/^\s+([^:]+): Playback \d+ \[(\d+)\%\]/){
                $vol->{$vol->{'last'}}->{$1} = $2;
                next;
            }
        }
    }
    return($vol);
}

for (@ARGV) {
    my $arg = $_;
    if ( $arg =~ /awesome/ ) {
        my ($vol,$lastvol);
        while(1){
            $vol = mix();
            if ( Dumper($vol) !~ Dumper($lastvol) ){
                notifyper("Volume", "Volume", `$0 Master` . "<br>" . `$0 PCM` . "<br>" . `$0 Front` , "/usr/share/gmpc/icons/hicolor/48x48/apps/gmpc.png");
            }
            $lastvol = $vol;
            sleep 1;
        }
    }   else {
        my $vol = mix();
        if ( defined $vol->{$arg} ){
            for (keys %{ $vol->{$arg} } ){
                print $arg . ":" . $_ . ":" . $vol->{$arg}->{$_} . "\n";
            }
        }else {
            exit 1;
        }
    }
}


sub notifyper {
    my ($class,$title,$message,$icon) = @_;
    open( AWESOME, "| tee /dev/stderr | awesome-client") or die $!; 
    print AWESOME "for i = 1, screen.count() " . 
        " do notify.$class = naughty.notify({title = \"$title\"," .
        " icon=\"$icon\", screen = i, text=\"$message\", " . 
        " timeout = 5 , replaces_id=notifys.$class.[i].id}) end\n";
    close AWESOME;
    sleep 1;
}




# vi: set ts=4 sw=4 et:

