
=head1 NAME

t/RT107039.t

=head1 DESCRIPTION

Tests formatting of obsolete entries.

	Invalid formatting of obsolete entries
	
	When one entry is obsoleted and have multiple lines
	of msgctxt/msgid/msgid_plural/msgstr/msgstr[*],
	save_file_fromarray and save_file_fromhash will generate
	invalid file: GNU gettext tools like megcat and msgattrib
	will abnormally be terminated with "fatal errors" and
	"inconsistent use of #~" messages.
	
	[1] https://rt.cpan.org/Ticket/Display.html?id=107039

=head1 EXAMPLE

	# Japanese translations for test package
	# test パッケージに対する英訳.
	# Copyright (C) 2015 THE test'S COPYRIGHT HOLDER
	# This file is distributed under the same license as the test package.
	# Automatically generated, 2015.
	#
	msgid ""
	msgstr ""
	"Project-Id-Version: test version\n"
	"Report-Msgid-Bugs-To: \n"
	"POT-Creation-Date: 2015-09-11 09:00+0900\n"
	"PO-Revision-Date: 2015-09-11 09:00+0900\n"
	"Last-Translator: Automatically generated\n"
	"Language-Team: none\n"
	"Language: ja\n"
	"MIME-Version: 1.0\n"
	"Content-Type: text/plain; charset=UTF-8\n"
	"Content-Transfer-Encoding: 8bit\n"
	"Plural-Forms: nplurals=1; plural=0;\n"

	#: test.c:13
	#, c-format
	#~ msgid "TEST: msgid singleline"
	#~ msgstr "TEST: msgstr singleline"

	#: test.c:14
	#, c-format
	#~ msgid "TEST: msgid multi\n"
	#~ "line"
	#~ msgstr "TEST: msgstr multi\n"
	#~ "line"

	#: test.c:17
	#, c-format
	#~ msgctxt "TEST: mgsctxt singleline"
	#~ msgid "TEST: msgid singleline"
	#~ msgid_plural "TEST: msgid_plural singleline"
	#~ msgstr[0] "TEST: msgstr[0] singleline"

	#: test.c:20
	#, c-format
	#~ msgctxt "TEST: mgsctxt multi\n"
	#~ "line"
	#~ msgid "TEST: msgid multi\n"
	#~ "line"
	#~ msgid_plural "TEST: msgid_plural multi\n"
	#~ "line"
	#~ msgstr[0] "TEST: msgstr[0] multi\n"
	#~ "line"

=cut

use strict;
use warnings;

use Test::More;
use Locale::PO;
use File::Temp qw/tempfile tempdir/;
use File::Compare;

my $no_tests = 2;

plan tests => $no_tests;

my $file = "t/RT107039.po";
my $aref = Locale::PO->load_file_asarray($file);
ok( $aref, "loaded ${file} file" );

my ( $tempfh, $tempfile ) = tempfile;
Locale::PO->save_file_fromarray( $tempfile, $aref );
close $tempfh;

ok( compare( $file, $tempfile ) == 0, "compare test" );

1;
