#!/usr/bin/perl

=head1 NAME

grepp -- Perl version of gnu/unix "grep"

=head1 SYNOPSIS

grepp [-chlnivz] [-d delim] [-r enc] {regex or -f rex.file}  [file_name(s)]

=head1 DESCRIPTION

These days, with more text files containing complicated foreign
languages and structured markup, the old standard "grep" utility just
isn't good enough, and "grepp" (written in Perl, hence the extra "p"
in the name) provides the extra abilities that have become daily
needs.

At present, grepp replicates only the most commonly used features of
grep (in terms of the "standard" command line options available), but
to compensate, grepp provides some important things that would be
impossible with grep.  In particular:

Text files that contain non-ASCII data, ranging from "vanilla"
single-byte (ISO Latin1, CP1252) to variable-width "tutti-frutti"
(ShiftJIS, Big5, GB, KSC, Unicode...) are hard to probe reliably,
unless you can specify the characters or regular expressions you're
looking for in the native language of the text, and grepp lets you do
that.

For non-Unicode encodings, it may be easiest to store the patterns you
want to find in a text file, one pattern per line, and use the "-f
file.name" option, instead of trying to enter a foreign language
pattern on the command line.

However, if you have access to a suitable terminal for using your
foreign language of choice (e.g. kterm, hanterm, cxterm, etc), you
could switch input modes while typing the grepp command line, in order
to specify a search pattern in Japanese, Korean, Chinese, etc, and
grepp will do the right thing with that.

Another alternative is to use Unicode 4-digit hexidecimal code points
(e.g. '\x{00f5}') in the regular expression to match characters
according to their Unicode definitions.  This is possible for any
lanuage -- and any input character encoding -- because grepp converts
all text data (and search expressions as well) into Unicode
internally, in order to look for matches.

By using Unicode for matching, grepp avoids "false alarms" that are
possible when searching for a given multi-byte character; for example,
if you search GB text for a Chinese character whose two-byte sequence
is, say "\xA1\xB4", a typical "grep" search would find "hits" on lines
that contain GB character pairs like "\xC2\xA1\xB4\xD1".  Since grepp
converts all text data into Unicode, the true boundaries between
multi-byte characters are always respected and maintained.  Of course,
grepp always writes its output using the same encoding as the input;
the text you get back is just like the text you put in (minus the
parts you do not want).

The use of Unicode also provides many handy "shortcuts" for finding
classes of characters that might otherwise be hard to enumerate, like
'\p{Punctuation}', '\p{Hebrew}', '\p{CurrencySymbol}', etc.  A
complete list of Unicode-based regex terms can be found in the
"perlunicode" man page.

Naturally, all of the traditional Perl regex shortcuts can be used as
well: '\s' (any white-space), '\d' (any ASCII digit), '\b' ("zero
width" word boundary condition), etc; the "perlre" man page provides a
complete explanation of these and many other useful extensions beyond
the scope of the standard "grep" program.  This makes grepp attractive
even for ASCII-only jobs.

Another novel feature is the ability to specify a "delimiter" string
of your own choosing, instead of the default line-feed "\n" character.
if this is 'undef', grepp will read the entire input text as a single
string, and will return it all if it happens to match the given search
condition(s).  You can also specify things like mark-up tags (e.g.
'</DOC>\n' or '</td>') or any specific character sequence (e.g.  '\t'
or '/').  this allows a search pattern to extend across line breaks,
and allows the output to be multi-line or partial-line, instead of
just single, whole lines.  Note that the delimiter cannot be treated
as a regular expression; it must be a literal string.

And, as a convenience, grepp will handle compressed files or data
streams as the input "text"; if you give it a file name ending in
".gz", ".z" or ".Z", or if you use the "-z" option when piping
compressed data on stdin, grepp will automatically uncompress the data
as it reads.  Any matches will be printed as uncompressed text (in the
specified encoding).

=cut

require 5.008_000;

use Getopt::Long;
use PerlIO::gzip;
use Encode;

($me = $0) =~ s%.*/%%;

$Usage = "
$me [-chlnivz] [-d delim] [-r enc] {regex or -f rex.file}  [file_name(s)]

 like 'grep', but handles perl regexes, wide characters, compressed text, ...

 -c  -- print total number of matches (not the matching text)
 -h  -- print lines of matching data only, not prefixed by file name
 -l  -- print just the file names that contain matches (not the data)
 -n  -- include line numbers when listing matches
    (note that these first four options are mutually exclusive)

 -i  -- ignore case distinctions when matching
 -v  -- invert search logic (print lines that do not match)
 -z  -- treat input data stream(s) as compressed text     (1)

 -f rex.file -- read search patterns from rex.file, one per line   (2) 
 -d delim -- use 'delim' as input record separator instead of '\\n' (3)
 -r enc   -- regex(es) and input data are in character set 'enc'   (4)

NOTES:
(1) file names '*.Z', '*.z' and '*.gz' are treated as compressed by default
(2) multiple regexes from a file are combined using 'or'; when used
       with '-v', we only list lines that match none of the regexes
(3) delim may be 'undef' or include \\n,\\t and/or \\r, but is NOT a regex
(4) use '-r help' for a list of supported character sets\n\n";

if ( @ARGV > 1 && $ARGV[0] =~ /^-[chilnvz]{2,}$/ ) {
    $arg = substr( $ARGV[0], 1 );   # a kluge to allow multiple option
    @args = split( //, $arg );      #  characters to be combined as a
    for (@args) { $_ = "-".$_ }     #  single arg on the command line
    splice( @ARGV, 0, 1, @args );   #  (e.g. "-nvi"), just like grep
}
die $Usage unless ( &GetOptions( 'n', 'l', 'v', 'i', 'h', 'z', 'c', 'd=s', 'f=s', 'r=s' ));
die $Usage unless (( $opt_n + $opt_l + $opt_h + $opt_c <2 ) &&
                   ( @ARGV >= 1 or $opt_f or $opt_r eq 'help' ));

my @enclist = Encode->encodings(":all"); # list of all supported character sets

listEncodings()    # this will exit when done
    if ( $opt_r =~ /\S/ and not grep( /^$opt_r$/, @enclist ));

if ( $opt_f ) {
    open( PTN, $opt_f ) or die "Unable to open regex file $opt_f: $!\n$Usage";
    while (<PTN>) {
        s/[\r\n]+//;
        push @ptns, $_;
    }
    close PTN;
    $ptn = join( '|', @ptns );
}
else {
    $ptn = shift;
}

$ptn = decode( $opt_r, $ptn ) if ( $opt_r );

$regex = ( $opt_i ) ?  qr/$ptn/io : qr/$ptn/o;

if ( $opt_d ) {
    my %esc = ( n => "\n",
                r => "\r",
                t => "\t"
                );
    foreach $e ( keys %esc ) {
        $opt_d =~ s/\\$e/$esc{$e}/g;
    }
    $/ = ( $opt_d eq 'undef' ) ? undef : "$opt_d";
}

$exstat = 1;
$|++;  #turn off buffering for STDOUT
$/ = "\x0a\x00" if ( $opt_r eq "UTF-16LE" );

if (@ARGV==0) {
    binmode( STDIN, "<:gzip" ) if ( $opt_z );
    while (<>) {
        $read = ( $opt_r ) ? decode( $opt_r, $_ ) : $_;
        if ( $opt_v ^ ( $read =~ /$regex/ )) {
            if ( $opt_l ) {
                print "$ptn found on stdin\n";
                exit(0);
            }
            elsif ( $opt_c ) {
                $matchCount++;
            }
            else {
                print "$.:" if ( $opt_n );
                print;
            }
            $exstat = 0;
        }
    }
    print "$matchCount\n" if ( $opt_c );
    exit( $exstat );
}

$preff = ( $opt_h ) ?  0 : ( @ARGV > 1 );

for $f ( @ARGV ) {
    $openMode = ( $f =~ /\.g?z$/i ) ? "<:gzip" : "<";
    unless ( open( INP, $openMode, $f )) {
        warn "Unable to open input file $f: $!\n";
        next;
    }
    $matchCount = 0;
    $pformat = ( $preff ) ? "$f:" : "";
    $pformat .= '$.:' if ( $opt_n );
    $pformat .= '%s';

    while (<INP>)
    {
        $read = ( $opt_r ) ? decode( $opt_r, $_ ) : $_;
        if ( $opt_v ^ ( $read =~ /$regex/ )) {
            if ( $opt_l ) {
                print "$f\n";
                $exstat = 0;
                last;
            }
            elsif ( $opt_c ) {
                $matchCount++;
            }
            else {
                eval "printf( \"$pformat\", \$_ )";
            }
            $exstat = 0;
        }
    }
    close INP;
    if ( $opt_c ) {
        print "$f:" if ( $preff );
        print "$matchCount\n";
    }
}
exit( $exstat );

sub listEncodings
{   # user is asking for help: list all available encodings
    my $colwidth = length( (sort {length($b) <=> length($a)} @enclist)[0] ) + 2;
    my $ncol = int( 80/$colwidth );
    my $nrow = int( scalar(@enclist)/$ncol );
    $nrow++ if ( scalar(@enclist) % $ncol );
    my $fmt = "%-${colwidth}s";

    print $Usage;
    foreach my $r ( 0 .. $nrow ) {
        foreach my $c ( 0 .. $ncol ) {
            my $i = $c * $nrow + $r;
            printf( $fmt, $enclist[$i] );
        }
        print "\n";
    }
    exit( 0 );
}
