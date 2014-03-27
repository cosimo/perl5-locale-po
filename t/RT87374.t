=head1 NAME

t/RT87374.t

=head1 DESCRIPTION

Check that PO files with Windows line endings can
be correctly loaded. In particular, the CR+LF combination
should be removed when file is loaded.

https://rt.cpan.org/Ticket/Display.html?id=87374

=cut

use strict;
use warnings;

use Test::More tests => 6;
use Locale::PO;
use Data::Dumper;

my $file = "t/RT87374.po";
my $po = Locale::PO->load_file_asarray($file);
ok $po, "loaded ${file} file";

my $out = $po->[0]->dump;
ok $out, "dumped po object";

ok(Locale::PO->save_file_fromarray("${file}.out", $po), "save again to file");
ok -e "${file}.out", "the file now exists";

my $po_after_rt = Locale::PO->load_file_asarray("${file}.out");
ok $po_after_rt, "loaded ${file}.out file"
    and unlink "${file}.out"; 

my $orig_entry = $po->[1];
my $new_entry  = $po_after_rt->[1];

is_deeply $orig_entry => $new_entry,
    "We have the same entry before and after a round trip";

is $new_entry->msgstr =>
    q("Some translated string"),
    "Windows line endings are correctly removed when loading a PO file";
