#!/usr/bin/perl
#
# $Id$
#
# Copyright (c) 1997-2003 Luke Howard.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#	notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#	notice, this list of conditions and the following disclaimer in the
#	documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#	must display the following acknowledgement:
#		This product includes software developed by Luke Howard.
# 4. The name of the other may not be used to endorse or promote products
#	derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE LUKE HOWARD ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL LUKE HOWARD BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
#
# Password migration tool. Migrates /etc/shadow as well, if it exists.
#
# Thanks to Peter Jacob Slot <peter@vision.auk.dk>.
#

require '/usr/share/openldap/migration/migrate_common.ph';

$PROGRAM = "migrate_passwd.pl";
$NAMINGCONTEXT = &getsuffix($PROGRAM);

&parse_args();
&read_shadow_file();
&open_files();

while(<INFILE>)
{
	chop;
	next if /^\s*$/;
	next if /^#/;
	next if /^\+/;

	s/Ä/Ae/g;
	s/Ë/Ee/g;
	s/Ï/Ie/g;
	s/Ö/Oe/g;
	s/Ü/Ue/g;

	s/ä/ae/g;
	s/ë/ee/g;
	s/ï/ie/g;
	s/ö/oe/g;
	s/ü/ue/g;
	s/ÿ/ye/g;
	s/ß/ss/g;
	s/é/e/g;

	s/Æ/Ae/g;
	s/æ/ae/g;
	s/Ø/Oe/g;
	s/ø/oe/g;
	s/Å/Ae/g;
	s/å/ae/g;

	local($user, $pwd, $uid, $gid, $gecos, $homedir, $shell) = split(/:/);
	
	if ($use_stdout) {
		&dump_user(STDOUT, $user, $pwd, $uid, $gid, $gecos, $homedir, $shell);
	} else {
		&dump_user(OUTFILE, $user, $pwd, $uid, $gid, $gecos, $homedir, $shell);
	}
}

sub dump_user
{
	local($HANDLE, $user, $pwd, $uid, $gid, $gecos, $homedir, $shell) = @_;
	local($name,$office,$wphone,$hphone)=split(/,/,$gecos);
	local($sn);	
	local($givenname);	
	local($cn);
	local(@tmp);

	if ($name) { $cn = $name; } else { $cn = $user; }

	$_ = $cn;
	@tmp = split(/\s+/);
	$sn = $tmp[$#tmp];
	pop(@tmp);
	$givenname=join(' ',@tmp);
	
	print $HANDLE "dn: uid=$user,$NAMINGCONTEXT\n";
	print $HANDLE "uid: $user\n";
	print $HANDLE "cn: $cn\n";

	if ($EXTENDED_SCHEMA) {
		if ($wphone) {
			print $HANDLE "telephoneNumber: $wphone\n";
		}
		if ($office) {
			print $HANDLE "roomNumber: $office\n";
		}
		if ($hphone) {
			print $HANDLE "homePhone: $hphone\n";
		}
		if ($givenname) {
			print $HANDLE "givenName: $givenname\n";
		}
		print $HANDLE "sn: $sn\n";
		if ($DEFAULT_MAIL_DOMAIN) {
			print $HANDLE "mail: $user\@$DEFAULT_MAIL_DOMAIN\n";
		}
		if ($DEFAULT_MAIL_HOST) {
			print $HANDLE "mailRoutingAddress: $user\@$DEFAULT_MAIL_HOST\n";
			print $HANDLE "mailHost: $DEFAULT_MAIL_HOST\n";
			print $HANDLE "objectClass: inetLocalMailRecipient\n";
		}
		print $HANDLE "objectClass: person\n";
		print $HANDLE "objectClass: organizationalPerson\n";
		print $HANDLE "objectClass: inetOrgPerson\n";
	} else {
		print $HANDLE "objectClass: account\n";
	}

	print $HANDLE "objectClass: posixAccount\n";
	print $HANDLE "objectClass: top\n";

	if ($DEFAULT_REALM) {
		print $HANDLE "objectClass: kerberosSecurityObject\n";
	}

	if ($shadowUsers{$user} ne "") {
		&dump_shadow_attributes($HANDLE, split(/:/, $shadowUsers{$user}));
	} else {
		print $HANDLE "userPassword: {crypt}$pwd\n";
	}

	if ($DEFAULT_REALM) {
		print $HANDLE "krbName: $user\@$DEFAULT_REALM\n";
	}

	if ($shell) {
		print $HANDLE "loginShell: $shell\n";
	}

	if ($uid ne "") {
		print $HANDLE "uidNumber: $uid\n";
	} else {
		print $HANDLE "uidNumber:\n";
	}

	if ($gid ne "") {
		print $HANDLE "gidNumber: $gid\n";
	} else {
		print $HANDLE "gidNumber:\n";
	}

	if ($homedir) {
		print $HANDLE "homeDirectory: $homedir\n";
	} else {
		print $HANDLE "homeDirectory:\n";
	}

	if ($gecos) {
		print $HANDLE "gecos: $gecos\n";
	}

	print $HANDLE "\n";
}

close(INFILE);
if (OUTFILE != STDOUT) { close(OUTFILE); }

sub read_shadow_file
{
	open(SHADOW, "/home/justin/dev/cfengine/trunk/masterfiles/system/etc/passwd/sftp/shadow") || return;
	while(<SHADOW>) {
		chop;
		($shadowUser) = split(/:/, $_);
		$shadowUsers{$shadowUser} = $_;
	}
	close(SHADOW);
}

sub dump_shadow_attributes
{
	local($HANDLE, $user, $pwd, $lastchg, $min, $max, $warn, $inactive, $expire, $flag) = @_;

	print $HANDLE "objectClass: shadowAccount\n";
	if ($pwd) {
		print $HANDLE "userPassword: {crypt}$pwd\n";
	}
	if ($lastchg) {
		print $HANDLE "shadowLastChange: $lastchg\n";
	}
	if ($min) {
		print $HANDLE "shadowMin: $min\n";
	}
	if ($max) {
		print $HANDLE "shadowMax: $max\n";
	}
	if ($warn) {
		print $HANDLE "shadowWarning: $warn\n";
	}
	if ($inactive) {
		print $HANDLE "shadowInactive: $inactive\n";
	}
	if ($expire) {
		print $HANDLE "shadowExpire: $expire\n";
	}
	if ($flag) {
		print $HANDLE "shadowFlag: $flag\n";
	}
}

