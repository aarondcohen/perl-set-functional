use Test::More tests => 24;

use strict;
use warnings;

use Set::Functional qw{:all};

sub order { sort { $a <=> $b } @_ }

my @arr_num1 = (1 .. 10);
my @arr_num2 = (6 .. 15);
my @arr_num3 = map { $_ * 2 } (1 .. 10);
my @arr_nums = (\@arr_num1, \@arr_num2, \@arr_num3);

my @result_set;

#Setify
is_deeply [setify], [], 'setify returns the empty set with no sets';
is_deeply [setify 10], [10], 'setify returns the only element with one set';
is_deeply
	[order setify @arr_num1, @arr_num2],
	[1 .. 15],
	'setify returns deduplicated elements with many inputs';
is_deeply
	[order setify map {$_} @arr_num1, @arr_num2],
	[1 .. 15],
	'setify works with internal iterators';

#Difference
is_deeply [difference], [], 'difference returns the empty set with no sets';
is_deeply [order difference \@arr_num1], \@arr_num1, 'difference returns the same elements with one set';
is_deeply
	[order difference @arr_nums],
	[1, 3, 5],
	'difference returns only the elements in the first set';
is_deeply
	[order difference map {$_} @arr_nums],
	[1, 3, 5],
	'difference works with internal iterators';

#Disjoint
is_deeply [disjoint], [], 'disjoint returns the empty set with no sets';
is_deeply [order disjoint \@arr_num1], [\@arr_num1], 'disjoint returns the same elements with one set';
is_deeply
	[map {[order @$_]} disjoint @arr_nums],
	[[1,3,5],[11,13,15],[16,18,20]],
	'disjoint returns associated sets with the elements that only occur once in all sets';
is_deeply
	[map {[order @$_]} disjoint map {$_} @arr_nums],
	[[1,3,5],[11,13,15],[16,18,20]],
	'disjoint works with internal iterators';

#Distinct
is_deeply [distinct], [], 'distinct returns the empty set with no sets';
is_deeply [order distinct \@arr_num1], \@arr_num1, 'distinct returns the same elements with one set';
is_deeply
	[order distinct @arr_nums],
	[1,3,5,11,13,15,16,18,20],
	'distinct returns the elements that only occur once in all sets';
is_deeply
	[order distinct map {$_} @arr_nums],
	[1,3,5,11,13,15,16,18,20],
	'distinct works with internal iterators';

#Intersection
is_deeply [intersection], [], 'intersection returns the empty set with no sets';
is_deeply [order intersection \@arr_num1], \@arr_num1, 'intersection returns the same elements with one set';
is_deeply
	[order intersection @arr_nums],
	[6,8,10],
	'intersection returns only the elements that occur in all sets';
is_deeply
	[order intersection map {$_} @arr_nums],
	[6,8,10],
	'intersection works with internal iterators';

#Union
is_deeply [union], [], 'union returns the empty set with no sets';
is_deeply [order union \@arr_num1], \@arr_num1, 'union returns the same elements with one set';
is_deeply
	[order union @arr_nums],
	[1 .. 16, 18, 20],
	'union returns all the elements that occur in any set';
is_deeply
	[order union map {$_} @arr_nums],
	[1 .. 16, 18, 20],
	'union works with internal iterators';

=head
is_deeply [setify_by], [], 'setify_by returns the empty set with no sets';
is_deeply [setify_by @arr1], \@arr1, 'setify_by returns the same elements with one set';
is_deeply [difference_by], [], 'difference_by returns the empty set with no sets';
is_deeply [difference_by @arr1], \@arr1, 'difference_by returns the same elements with one set';
is_deeply [disjoint_by], [], 'disjoint_by returns the empty set with no sets';
is_deeply [disjoint_by @arr1], \@arr1, 'disjoint_by returns the same elements with one set';
is_deeply [distinct_by], [], 'distinct_by returns the empty set with no sets';
is_deeply [distinct_by @arr1], \@arr1, 'distinct_by returns the same elements with one set';
is_deeply [intersection_by], [], 'intersection_by returns the empty set with no sets';
is_deeply [intersection_by @arr1], \@arr1, 'intersection_by returns the same elements with one set';
is_deeply [union_by], [], 'union_by returns the empty set with no sets';
is_deeply [union_by @arr1], \@arr1, 'union_by returns the same elements with one set';
=cut
