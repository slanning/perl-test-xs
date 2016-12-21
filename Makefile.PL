use strict;
use warnings;
use ExtUtils::MakeMaker;

my @inc = ();
my @libs = ();

my $pkg = 'Scotttest';
WriteMakefile(
    NAME => $pkg,
    VERSION_FROM => "$pkg.pm",
    ABSTRACT_FROM => "$pkg.pm",
    AUTHOR => 'Scott Lanning <slanning@cpan.org>',
    MAN3PODS => {},
    META_MERGE => {
        no_index => {
            directory => [ qw/t examples genscripts/ ],
        },
    },
    INC  => join(' ', @inc),
    LIBS => join(' ', @libs),

    # why do I have to add this to suppress the `make` warning
    # when it's already the default?
    XSPROTOARG => '-noprototypes',
);
