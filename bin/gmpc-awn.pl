#!/usr/bin/perl

use Net::DBus;

# $songdir = "/mpd/music/dir"; # If defined, look for cover in the current song folder
$show_cover = 1;
$show_progress = 2; # 1 for circle progress and 2 to show time
$launcher = "gmpc"; # name of the launcher in AWN

$home = $ENV{'HOME'};

my $bus = Net::DBus->find;

my $awn = $bus->get_service("com.google.code.Awn");
my $manager = $awn->get_object("/com/google/code/Awn", "com.google.code.Awn");

while (1) {
	if ($show_progress == 1) {
		$paused1 = `mpc | grep -n 1`;
		$paused1 =~ /\[([a-z]+)\]/i;
		$paused = $1;
		if ($paused eq "paused") {
			eval {
				$manager->SetProgressByName($launcher, 100);
				$manager->SetInfoByName($launcher, "Paused");
			};
			if ($@ =~ /ServiceUnknown/) {
				print "Please launch AWN\n";
				sleep 10;
				redo;
			}
		}
		else {
			$time = $paused1;
			$time =~ /\(([0-9]+)%\)/i;
			$time = $1;
			eval {
			$manager->SetProgressByName($launcher, $time);
			};
			if ($@ =~ /ServiceUnknown/) {
				print "Please launch AWN\n";
				sleep 10;
				redo;
			}
		}
	}
	elsif ($show_progress == 2) {
		$paused = `mpc | grep -n 1`;
		chomp $paused;
		if ($paused =~ /paused/) {
			eval {
				$manager->SetInfoByName($launcher, "Paused");
			};
			if ($@ =~ /ServiceUnknown/) {
				print "Please launch AWN\n";
				sleep 10;
				redo;
			}
		}
		else {
			$paused =~ / ([0-9]+:[0-9]{2})\//i; # grep time
			$time = $1;
			eval {
			$manager->SetInfoByName($launcher, $time);
			};
			if ($@ =~ /ServiceUnknown/) {
				print "Please launch AWN\n";
				sleep 10;
				redo;
			}
		}
	}
	else {
		# $manager->SetProgressByName($launcher, 100); # useless
		# $manager->UnsetInfoByName($launcher);
	}

	if ($show_cover) {
		$aa = `mpc --format  '[%artist%<AND>%album%<AND>%file%]' | head -n 1`;
		$aa =~ /(.+)\<AND\>(.+)\<AND\>(.+)/;
		$artist = $1;
		$album = $2;
		$dir = $3;
		$artist =~ s/-/%2D/gi;
		$album =~ s/-/%2D/gi;
		$title = ''.$artist.'-'.$album.'';
		$title =~ s/\([^)]+\)//gi;
		$title =~ s/ /%20/gi;
		$title =~ s/\./%2E/gi;
		$title =~ s/!/%21/gi;
		$title =~ s/é/e/gi;
		$title =~ s/è/e/gi;
		$title =~ s/\,/%2C/gi;
		$title =~ s/\:/%3A/gi;
		$title = ''.$home.'/.covers/'.$title.'.jpg';
		if (-e $title) {
			eval {
			$manager->SetTaskIconByName($launcher, $title);
			};
			if ($@ =~ /ServiceUnknown/) {
				print "Please launch AWN\n";
				sleep 10;
				redo;
			}
		}
		elsif (defined($songdir) && $lastalbum ne $album) {
			$dir =~ s/\/[^\/]+$//gi;
			$dir = ''.$songdir.'/'.$dir.'';
			@img = `ls "$dir" | grep -i -e jpe*g`; # image files in the song folder
			$nocover = 1; # if no cover is found, remove the image
			foreach $image (@img) {
				chomp $image;
				if ($image =~ /folder|front|cover|large/i) {
					$dir = ''.$dir.'/'.$image.'';
					if (-e $dir) {
						eval {
						$manager->SetTaskIconByName($launcher, $dir);
						$nocover = 0;
						};
						if ($@ =~ /ServiceUnknown/) {
							print "Please launch AWN\n";
							sleep 10;
							redo;
						}
					}
				}
			}
			if ($nocover) {
				eval {
				$manager->UnsetTaskIconByName($launcher);
				};
				if ($@ =~ /ServiceUnknown/) {
					print "Please launch AWN\n";
					sleep 10;
					redo;
				}
				$nocover = 0;
			}
		}
		$lastalbum = $album;
	}
	sleep(1);
}
