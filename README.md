# NAME

Set::Functional - set operations for functional programming

# VERSION

Version 1.04

# SYNOPSIS

This module provides basic set operations for native lists.  The primary goal
is to take advantage of Perl's native functional programming capabilities
while relying solely on Pure Perl constructs to perform the set operations as
fast as possible.  All of these techniques have been benchmarked against other
common Perl idioms to determine the optimal solution.  These benchmarks can
be found in this package (shortly).

Each function is provided in two forms.  The first form always expects simple
flat data structures of defined elements.  The second form expects a BLOCK
(referred to as a choice function) to evaluate each member of the list to a
defined value to determine how the element is a set member.  These can be
identified by the suffix "\_by".  None of these functions check definedness
inline so as to eliminate the costly O(n) operation.  All functions have been
prototyped to give them a native Perl-ish look and feel.

Example usage:

        use Set::Functional ':all';

        # Set Creation
        my @deduped_numbers = setify(1 .. 10, 2 .. 11);
        my @deduped_objects_by_name = setify_by { $_->{name} } ({name => 'fred'}, {name => 'bob'}, {name => 'fred'});

        # Set Operation
        my @all_permutations = cartesian \@arr1, \@arr2, \@arr3, \@arr4;

        my @only_arr1_elements = difference \@arr1, \@arr2, \@arr3, \@arr4;
        my @only_arr1_elements_by_name = difference_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

        my @unique_per_set = disjoint \@arr1, \@arr2, \@arr3, \@arr4;
        my @unique_per_set_by_name = disjoint_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

        my @unique_elements = distinct \@arr1, \@arr2, \@arr3, \@arr4;
        my @unique_elements_by_name = distinct_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

        my @shared_elements = intersection \@arr1, \@arr2, \@arr3, \@arr4;
        my @shared_elements_by_name = intersection_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

        my @odd_occuring_elements = symmetric_difference \@arr1, \@arr2, \@arr3, \@arr4;
        my @odd_occuring_elements_by_name = symmetric_difference_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

        my @all_elements = union \@arr1, \@arr2, \@arr3, \@arr4;
        my @all_elements_by_name = union_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

        # Set Predicates
        my $is_all_of_arr1_distinct_from_arr2 = is_disjoint \@arr1, \@arr2;
        my $is_all_of_arr1_distinct_from_arr2_by_name = is_disjoint_by { $_->{name} } \@arr1, \@arr2;

        my $is_arr1_the_same_as_arr2 = is_equal \@arr1, \@arr2;
        my $is_arr1_the_same_as_arr2_by_name = is_equal_by { $_->{name} } \@arr1, \@arr2;

        my $are_all_sets_mutually_unique = is_pairwise_disjoint \@arr1, \@arr2, \@arr3, \@arr4;
        my $are_all_sets_mutually_unique_by_name = is_pairwise_disjoint_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

        my $is_all_of_arr1_in_arr2_but_not_the_same_as_arr2 = is_proper_subset \@arr1, \@arr2;
        my $is_all_of_arr1_in_arr2_but_not_the_same_as_arr2_by_name = is_proper_subset_by { $_->{name} } \@arr1, \@arr2;

        my $is_all_of_arr1_in_arr2 = is_subset \@arr1, \@arr2;
        my $is_all_of_arr1_in_arr2_by_name = is_subset_by { $_->{name} } \@arr1, \@arr2;

        my $is_all_of_arr2_in_arr1_but_not_the_same_as_arr1 = is_proper_superset \@arr1, \@arr2;
        my $is_all_of_arr2_in_arr1_but_not_the_same_as_arr1_by_name = is_proper_superset_by { $_->{name} } \@arr1, \@arr2;

        my $is_all_of_arr2_in_arr1 = is_superset \@arr1, \@arr2;
        my $is_all_of_arr2_in_arr1_by_name = is_superset_by { $_->{name} } \@arr1, \@arr2;

# CONSTRUCTORS

## setify(@)

Given a list, return a new set.  Order is not guaranteed.

        setify 1 .. 10, 6 .. 15 => 1 .. 15

## setify\_by(&@)

Given a choice function and a list, return a new set defined by the choice
function. Order is not guaranteed.

# OPERATORS

## cartesian(@)

Given multiple set references, return multiple sets containing all permutations
of one element from each set.  If the empty set is provided, no sets are
returned since the number of sets generated should be the product of the input
sets' cardinalities.  If no sets are provided then none are returned.

        cartesian [1 .. 3], [1 .. 2] => [1,1],[1,2],[2,1],[2,2],[3,1],[3,2]
        cartesian => ()
        cartesian [1 .. 3], [] => ()

## difference(@)

Given multiple set references, return a new set with all the elements in the first set
that don't exist in subsequent sets.

        difference [1 .. 10], [6 .. 15] => 1 .. 5

## difference\_by(&@)

Given a choice function and multiple set references, return a new set with all the elements
in the first set that don't exist in subsequent sets according to the choice function.

## disjoint(@)

Given multiple set references, return corresponding sets containing all the elements from
the original set that exist in any set exactly once.

        disjoint [1 .. 10], [6 .. 15] => [1 .. 5], [11 .. 15]

## disjoint\_by(&@)

Given a choice function and multiple set references, return corresponding sets containing
all the elements from the original set that exist in any set exactly once
according to the choice function.

## distinct(@)

Given multiple set references, return a new set containing all the elements that exist
in any set exactly once.

        distinct [1 .. 10], [6 .. 15] => 1 .. 5, 11 .. 15

## distinct\_by(&@)

Given a choice function and multiple set references, return a new set containing all the
elements that exist in any set exactly once according to the choice function.

## intersection(@)

Given multiple set references, return a new set containing all the elements that exist
in all sets.

        intersection [1 .. 10], [6 .. 15] => 6 .. 10

## intersection\_by(&@)

Given a choice function and multiple set references, return a new set containing all the
elements that exist in all sets according to the choice function.

## symmetric\_difference(@)

Given multiple set references, return a new set containing all the elements that
exist an odd number of times across all sets.

        symmetric_difference [1 .. 10], [6 .. 15], [4, 8, 12] => 1 .. 5, 8, 11 .. 15

## symmetric\_difference\_by(&@)

Given a choice function and multiple set references, return a new set containing
all the elements that exist an odd number of times across all sets according to
the choice function.

## union(@)

Given multiple set references, return a new set containing all the elements that exist
in any set.

        union [1 .. 10], [6 .. 15] => 1 .. 15

## union\_by(&@)

Given a choice function and multiple set references, return a new set containing all the
elements that exist in any set according to the choice function.

# PREDICATES

## is\_disjoint($$)

Given two set references, return true if both sets contain none of the same values.

        is_disjoint [1 .. 5], [6 .. 10] => true
        is_disjoint [1 .. 6], [4 .. 10] => false

## is\_disjoint\_by(&$$)

Given a choice function and two sets references, return true if both sets
contain none of the same values according to the choice function.

## is\_equal($$)

Given two set references, return true if both sets contain all the same values.
Aliased by is\_equivalent.

        is_equal [1 .. 5], [1 .. 5] => true
        is_equal [1 .. 10], [6 .. 15] => false

## is\_equal\_by(&$$)

Given a choice function and two sets references, return true if both sets
contain all the same values according to the choice function.
Aliased by is\_equivalent\_by.

## is\_pairwise\_disjoint(@)

Given multiple set references, return true if every set is disjoint from every
other set.

        is_pairwise_disjoint [1 .. 5], [6 .. 10], [11 .. 15] => true
        is_pairwise_disjoint [1 .. 5], [6 .. 10], [11 .. 15], [3 .. 8] => false

## is\_pairwise\_disjoint\_by(&@)

Given a choice function and multiple set references, return true if every set
is disjoint from every other set according to the choice function.

## is\_proper\_subset($$)

Given two set references, return true if the first set is fully contained by
but is not equivalent to the second.

        is_proper_subset [1 .. 5], [1 .. 10] => true
        is_proper_subset [1 .. 5], [1 .. 5] => false

## is\_proper\_subset\_by(&$$)

Given a choice function and two set references, return true if the first set
is fully contained by but is not equivalent to the second according to the
choice function.

## is\_proper\_superset($$)

Given two set references, return true if the first set fully contains but is
not equivalent to the second.

        is_proper_superset [1 .. 10], [1 .. 5] => true
        is_proper_superset [1 .. 5], [1 .. 5] => false

## is\_proper\_superset\_by(&$$)

Given a choice function and two set references, return true if the first set
fully contains but is not equivalent to the second according to the choice
function.

## is\_subset($$)

Given two set references, return true if the first set is fully contained by
the second.

        is_subset [1 .. 5], [1 .. 10] => true
        is_subset [1 .. 5], [1 .. 5] => true
        is_subset [1 .. 5], [2 .. 11] => false

## is\_subset\_by(&$$)

Given a choice function and two set references, return true if the first set
is fully contained by the second according to the choice function.

## is\_superset($$)

Given two set references, return true if the first set fully contains the
second.

        is_superset [1 .. 10], [1 .. 5] => true
        is_superset [1 .. 5], [1 .. 5] => true
        is_subset [1 .. 5], [2 .. 11] => false

## is\_superset\_by(&$$)

Given a choice function and two set references, return true if the first set
fully contains the second according to the choice function.

# AUTHOR

Aaron Cohen, `<aarondcohen at gmail.com>`

Special thanks to:
[Logan Bell](http://metacpan.org/author/logie)
[Thomas Whaples](https://github.com/twhaples)
[Dibin Pookombil](https://github.com/dibinp)

# BUGS

Please report any bugs or feature requests to `bug-set-functional at rt.cpan.org`, or through
the web interface at [https://github.com/aarondcohen/Set-Functional/issues](https://github.com/aarondcohen/Set-Functional/issues).  I will
be notified, and then you'll automatically be notified of progress on your bug as I make changes.

# TODO

- Add SEE ALSO section

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Set::Functional

You can also look for information at:

- Official GitHub Repo

    [https://github.com/aarondcohen/Set-Functional](https://github.com/aarondcohen/Set-Functional)

- GitHub's Issue Tracker (report bugs here)

    [https://github.com/aarondcohen/Set-Functional/issues](https://github.com/aarondcohen/Set-Functional/issues)

- CPAN Ratings

    [http://cpanratings.perl.org/d/Set-Functional](http://cpanratings.perl.org/d/Set-Functional)

- Official CPAN Page

    [http://search.cpan.org/dist/Set-Functional/](http://search.cpan.org/dist/Set-Functional/)

# LICENSE AND COPYRIGHT

Copyright 2011-2014 Aaron Cohen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
