#!/usr/bin/perl
# Author: Todd Larason <jtl@molehill.org>
# Modified by: Justin Hoppensteadt <256@justinhoppensteadt.com>
# $XFree86: xc/programs/xterm/vttests/256colors2.pl,v 1.2 2002/03/26 01:46:43 dickey Exp $

# use the resources for colors 0-15 - usually more-or-less a
# reproduction of the standard ANSI colors, but possibly more
# pleasing shades
# colors 16-231 are a 6x6x6 color cube
for ($red = 0; $red < 6; $red++) {
    for ($green = 0; $green < 6; $green++) {
	    for ($blue = 0; $blue < 6; $blue++) {

	        printf("\x1b]4;%d;rgb:%2.2x/%2.2x/%2.2x\x1b\\",
		            16 + ($red * 36) + ($green * 6) + $blue,
		            ($red ? ($red * 40 + 55) : 0),
		            ($green ? ($green * 40 + 55) : 0),
		            ($blue ? ($blue * 40 + 55) : 0));
	    }
    }
}

# colors 232-255 are a grayscale ramp, intentionally leaving out
# black and white
for ($gray = 0; $gray < 24; $gray++) {
    $level = ($gray * 10) + 8;
    printf("\x1b]4;%d;rgb:%2.2x/%2.2x/%2.2x\x1b\\",
	   232 + $gray, $level, $level, $level);
}


# display the colors

# first the system ones:
print "System colors:\n";
for ($co = 0 ; $co <2 ; $co++ ){
    for ($color = 0; $color < 8; $color++) {
        my $fcolor = sprintf("%4d", $color);
        print "\x1b[48;5;${color}m" if ( $co == 0 );
        print " $fcolor ";
    }
    print "\x1b[0m\n";
}
for ($co = 0 ; $co <2 ; $co++ ){
    for ($color = 8; $color < 16; $color++) {
        my $fcolor = sprintf("%4d", $color);
        print "\x1b[48;5;${color}m" if ( $co == 0 );
        print " $fcolor ";
    }
    print "\x1b[0m\n";
}
print "\x1b[0m\n";

# now the color cube
print "Color cube, 6x6x6:\n";
for ($green = 0; $green < 6; $green++) {
    for ($red = 0; $red < 6; $red++) {
	        for ($blue = 0; $blue < 6; $blue++) {
	            $color = 16 + ($red * 36) + ($green * 6) + $blue;
                my $fcolor = sprintf("%3d", $color);
	            #print "\x1b[48;5;${color}m$fcolor\x1b[0m$fcolor";
	            print "\x1b[48;5;${color}m$fcolor\x1b[0m$fcolor";
	        }
        print "\n";
    }
    print "\n";
}


# now the grayscale ramp
print "Grayscale ramp:\n";
for ($co = 0 ; $co <2 ; $co++ ){
    for ($color = 232; $color < 256; $color++) {
        my $fcolor = sprintf("%4d", $color);
        print "\x1b[48;5;${color}m" if ($co == 0);
        print "$fcolor";
    }
    print "\x1b[0m\n";
}
print "\x1b[0m\n";
