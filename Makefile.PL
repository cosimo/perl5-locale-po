use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME      => 'Locale::PO',
    PREREQ_PM => {
        'File::Slurp' => 0,
        'Test::More'  => 0,
    },
    VERSION_FROM => 'PO.pm',    # finds $VERSION
);
