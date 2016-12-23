package Scotttest;

require Exporter;
push @{ __PACKAGE__ . '::ISA' }, qw/Exporter/;   # no strict 'refs'

use strict;
use warnings;
use Carp;

our $VERSION = '0.01';

use XSLoader ();

XSLoader::load(__PACKAGE__, $VERSION);

our %EXPORT_TAGS = (
);

$EXPORT_TAGS{'all'} = [
    'test_dump',
    'test_dump_avar',
    'A_TEST_DUMP_FORMAT',
    map { @{ $EXPORT_TAGS{$_} } } keys %EXPORT_TAGS
];
our @EXPORT_OK = @{ $EXPORT_TAGS{'all'} };
our @EXPORT = ();


sub test_dump_print {
    my ($fh, $str, @args) = @_;
    printf($fh $str, @args);
    return;
}


1;
__END__

=head1 NAME

Scotttest - hey

=head1 SYNOPSIS

  use Scotttest;

=head1 DESCRIPTION

Whatever

=head1 AUTHOR

Scott Lanning E<lt>slanning@cpan.orgE<gt>

For licensing info, see F<README.txt>.

=cut

