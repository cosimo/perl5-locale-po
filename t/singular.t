use strict;
use warnings;

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use Test::More 'no_plan';
use File::Slurp;

use_ok 'Locale::PO';

my $po = new Locale::PO(
    -msgid   => 'This is not a pipe',
    -msgstr  => "",
    -comment =>
"The entry below is\ndesigned to test the ability of the comment fill code to properly wrap long comments as also to properly normalize the po entries. Apologies to Magritte.",
    -fuzzy => 1
);
ok $po, "got a po object";

my $out = $po->dump;
ok $out, "dumped the po object";

my @po = $po;
$po = new Locale::PO(
    -msgid  => '',
    -msgstr => "Project-Id-Version: PACKAGE VERSION\\n"
      . "PO-Revision-Date: YEAR-MO-DA HO:MI +ZONE\\n"
      . "Last-Translator: FULL NAME <EMAIL\@ADDRESS>\\n"
      . "Language-Team: LANGUAGE <LL\@li.org>\\n"
      . "MIME-Version: 1.0\\n"
      . "Content-Type: text/plain; charset=CHARSET\\n"
      . "Content-Transfer-Encoding: ENCODING\\n"
);
ok @po, "got the array";
ok $po, "got the po object";

unshift @po, $po;
ok Locale::PO->save_file_fromarray( "t/test1.pot.out", \@po ),
  "save file from array";

ok -e "t/test1.pot.out", "the file was created";

is(
    read_file("t/test1.pot"),
    read_file("t/test1.pot.out"),
    "found no matches - good"
  )
  && unlink("t/test1.pot.out");

################################################################################
#
# Do some roundtrip tests.
#

my $pos = Locale::PO->load_file_asarray("t/test.pot");
ok $pos, "loaded test.pot file";

$out = $pos->[0]->dump;
ok $out, "dumped po object";

is($pos->[1]->loaded_line_number, 16, "got line number of 2nd po entry");

ok Locale::PO->save_file_fromarray( "t/test.pot.out", $pos ), "save to file";
ok -e "t/test.pot.out", "the file now exists";

is(
    read_file("t/test.pot"),
    read_file("t/test.pot.out"),
    "found no matches - good"
  )
  && unlink("t/test.pot.out");

