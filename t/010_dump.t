#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use File::Temp qw/tempfile/;
use Test::More tests => 2;

use Scotttest qw/test_dump/;

my $output_format = "This was your string: %s\n";   # what test_dump outputs
my $testname = "test0";

{
    $testname++;

    my ($fh, $filename) = tempfile(undef, UNLINK => 1);
    test_dump($fh, $testname);
    close($fh);

    open(my $fh2, $filename);
    my $buf = do { local $/; <$fh2> };
    close($fh2);
    is($buf, sprintf($output_format, $testname), $testname);
}

{
    $testname++;

    my $buf;
    open(my $fh, ">", \$buf);
    test_dump($fh, $testname);
    close($fh);
    is($buf, sprintf($output_format, $testname), $testname);
}
