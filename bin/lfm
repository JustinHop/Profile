#!/usr/bin/perl

# -----------------------------------------
# Program : lfmCMD.pl (Last.fm Command Line Utility)
# Author  : Klaus Tockloth <Klaus DOT Tockloth AT googlemail DOT com>
# Version : 0.1-28.02.2009
# -----------------------------------------

use warnings;
use strict;

use File::Basename;
use LWP::UserAgent;
use URI::QueryParam;
use Encode;
use XML::Simple;
use Digest::MD5 qw(md5_hex);
use Data::Dumper;

my $lastfm_api_key = '0996e89f272c714ec0bd463ea17faf6c';
my $lastfm_api_secret = 'aced25823414f7398e60a0323eff1741';

my $lastfm_service_root = 'http://ws.audioscrobbler.com/2.0/'; 
my $lastfm_service_uri = ''; 

my $lastfm_response = '';
my $lastfm_xmlref = '';

my %params = ();
my $rc = 0;

# set STDOUT and STDERR to utf8 output devices
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

my $appname = fileparse($0);
print "\n$appname - Last.fm Command Line Utility, Rel. 0.1-28.02.09, Author: Klaus Tockloth\n\n";

if ($#ARGV < 0) { 
	show_help();
}	    

# copy the key/value pairs into a hash (enforce utf8 encoding)
for (my $i = 0; $i <= $#ARGV; $i++) {
  my ($key, $value) = split /=/, $ARGV[$i], 2;
  $params{$key} = encode("utf8", $value);  
}

# create an internet user agent                   
my $ua = LWP::UserAgent->new;    
$ua->agent("lfmCMD/0.1");                     
$ua->timeout(20);

# Proxy setting = schema://[user[:password]@]server[:port]
# e.g. 'http://10.88.180.22:8080' 
# e.g. 'http://apple777:secret88@proxy.apple.de:8080'
# $ua->proxy('http', 'http://apple777:secret768@10.68.188.44:8080');                                  

print "last.fm request:\n----------------\n";
print "Timestamp .....: " . localtime(time) . "\n";

# add "api_key" to "%params"
$params{api_key} = $lastfm_api_key;

# build the hash string                  
my $hashstring = '';
foreach my $key (sort keys %params) {
  my $value = $params{$key};
  print "Parameter .....: $key = " . decode_utf8($value) . "\n";
  $hashstring .= $key . $value;
}
# add "api_secret" to hash string                 
$hashstring .= $lastfm_api_secret;

# calculate hash value and add "api_sig" to "%params"
$params{api_sig} = md5_hex($hashstring);

# build URI (last.fm request) (inclusive UTF8 escaping)
$lastfm_service_uri = URI->new($lastfm_service_root);
foreach my $key (sort keys %params) {
  my $value = $params{$key};  
  $lastfm_service_uri->query_param($key, $value); 
}
print "Service URI ...: $lastfm_service_uri\n";

# use "post" (instead of "get") if "sk" (session key) is given
if (defined($params{sk})) {
	# last.fm write service
  $lastfm_response = $ua->post($lastfm_service_uri);
}
else {
	# last.fm read service
  $lastfm_response = $ua->get($lastfm_service_uri);
}
print "\nlast.fm response:\n-----------------\n";
print "http status ...: " . $lastfm_response->status_line . "\n";
  
# transfer xml response to perl data structure - force everything into arrays
$lastfm_xmlref = XMLin($lastfm_response->decoded_content, ForceArray => 1);

print "last.fm status : " . $lastfm_xmlref->{status} . "\n";
# print "Parsed xml     :\n" . Dumper($lastfm_xmlref) . "\n";

$rc = 0;  
if (! $lastfm_response->is_success) {                        
	print "error code ....: " . $lastfm_xmlref->{error}->[0]->{code} . "\n";                    
	print "error content .: " . $lastfm_xmlref->{error}->[0]->{content} . "\n";
	$rc = 2;
}   

print STDERR $lastfm_response->decoded_content;  

# return codes: 0=successful; 1=help screen; 2=not successful
exit ($rc);


# -----------------------------------------
# Show help and exit. 
# ----------------------------------------- 
sub show_help {
  print "Usage:\n" .
        "$appname method=\"name\" [param1=\"value\"] ... [paramN=\"value\"]\n" .
        "\n" .
        "Examples (read/get services):\n" .
        "$appname method=\"tag.getTopArtists\" tag=\"disco\"\n" .
        "$appname method=\"artist.getInfo\" artist=\"Cher\"  2>artist.getInfo.Cher.xml\n" .
        "$appname method=\"album.getInfo\" artist=\"Cher\" album=\"Believe\"  2>album.getInfo.Cher.Believe.xml\n" .
        "$appname method=\"user.getPlaylists\" user=\"apple777\"  2>user.getPlaylists.apple777.xml\n" .
        "$appname method=\"playlist.fetch\" playlistURL=\"lastfm://playlist/album/2026126\"\n" .
        "\n" .        
        "Examples (write/post services; replace \"sk\", \"playlistID\", ... with your data):\n" .
        "$appname method=\"playlist.create\" title=\"Best of Cher\" description=\"Nutrimentum spiritus.\" sk=\"3a50000000000000000000000000030b\"\n" .
        "$appname method=\"playlist.addTrack\" playlistID=\"4441934\" track=\"Runaway\" artist=\"Cher\" sk=\"3a50000000000000000000000000030b\"\n" .
        "\n" .
        "Parameters:\n" .
        "method: method name (method=\"name\")\n" . 
        "param1: method parameter 1 (param1=\"value\")\n" .
        "paramN: method parameter N (paramN=\"value\")\n" .
        "\n" .
        "General information:\n" .
        "- The last.fm xml response is send to STDERR (2), everything else to STDOUT (1).\n" .
        "- STDERR and STDOUT are written in utf8 format.\n" .
        "- Use the power of redirection (e.g. 1>Request.txt 2>Response.xml).\n" .
        "- Use batch files for your convenience (e.g. user.getPlaylists.cmd; consider your chcp setting).\n" .
        "- Use a good editor (e.g. microsoft xml notepad, notepad++) to visualize the outputs.\n" . 
        "\n" .
        "Proxy support:\n" .
        "- Proxy support is given, but it is deactivated by default.\n" .
        "- Have a look into the source code (e.g. search for \"proxy\").\n" .
        "- Fill in your proxy settings and uncomment the appropriate line.\n" .
        "\n" .
        "How to get a session key (sk)? (This is only required once!):\n" .
        "1. Call method \"auth.getToken\":\n" .
        "   - e.g. $appname method=\"auth.getToken\"\n" .
        "   - You will get a token (60 minutes valid) in the last.fm xml response.\n" .
        "2. Authorize lfmCMD to access your last.fm account:\n" .
        "   - Open your standard browser and login to your last.fm account.\n" . 
        "   - Build an URI like this: http://www.last.fm/api/auth/?api_key=<API_KEY>&token=<TOKEN>\n" .
        "     - api_key: see source code\n" . 
        "     - token: see step 1\n" .
        "     - e.g. http://www.last.fm/api/auth/?api_key=09900000000000000000000000000f6c&token=519000000000000000000000000005c7\n" .
        "     - open URI in your browser (you will see the last.fm application permission page)\n" .
        "     - grant permission to lfmCMD / wait some seconds for last.fm server processing\n" .
        "3. Call method \"auth.getSession\":\n".
        "   - e.g. $appname method=\"auth.getSession\" token=\"519000000000000000000000000005c7\"\n" .
        "     - token: see step 1\n" .
        "   - You will get a session key (sk) (infinite valid) in the last.fm xml response.\n" .
        "4. Session key:\n" .
        "   - Keep the session key save (similar to a password).\n" .
        "   - Everybody who knows your session key has write access to your account.\n" .
        "   - You can invalidate the session key by removing this application.\n" .
        "   - Removing is done on the settings page of your last.fm profile.\n";
  exit(1);
}	
