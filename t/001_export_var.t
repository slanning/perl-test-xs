#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 1;

use Scotttest qw/A_TEST_DUMP_FORMAT/;

my $expected = "This was your string: %s\n";
is(A_TEST_DUMP_FORMAT, $expected, "exported variable A_TEST_DUMP_FORMAT works");
