
=head1 NAME

t/RT119945.t

=head1 DESCRIPTION

Tests dequoting of C<\t> characters in msgid strings

See: L<https://rt.cpan.org/Ticket/Display.html?id=107039>

=cut

use strict;
use warnings;

use Test::More;
use Locale::PO;
use File::Temp;
use File::Compare;

plan tests => 5;

my $file = "t/RT119945.po";
my $entries = Locale::PO->load_file_asarray($file);
ok($entries, "loaded ${file} file");

for my $entry (@$entries) {
    my $quoted_msgid = $entry->msgid;
    my $quoted_msgstr = $entry->msgstr;

    my $msgid = $entry->dequote($quoted_msgid);
    my $msgstr = $entry->dequote($quoted_msgstr);

    unlike(
        $msgid,
        qr{\\t},
        "msgid containing quoted tab characters is dequoted correctly"
    );

    unlike(
        $msgid,
        qr{\\n},
        "msgid containing newline characters is dequoted correctly"
    );

    unlike(
        $msgstr,
        qr{\\t},
        "msgstr containing quoted tab characters is dequoted correctly"
    );

    unlike(
        $msgstr,
        qr{\\n},
        "msgstr containing newline characters is dequoted correctly"
    );

}
