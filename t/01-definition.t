use Test::More tests => 3;

use strict;
use warnings;

use Set::Functional qw{:all};

my @result_set;

is_deeply [setify], [], 'setify returns the empty list with no input';
is_deeply [setify 10], [10], 'setify returns the only element with one input';
is_deeply
	[sort { $a <=> $b } setify (1 .. 10, 2 .. 8)],
	[1 .. 10],
	'setify returns deduplicated elements with many inputs';

