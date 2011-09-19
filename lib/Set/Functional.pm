package Set::Functional;

use 5.006;

use Exporter qw{import};

=head1 NAME

Set::Functional - set operations for functional programming

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

our @EXPORT_OK  = qw{
	setify setify_by
	difference difference_by
	disjoint disjoint_by
	distinct distinct_by
	intersection intersection_by
	union union_by
};
our %EXPORT_TAGS = (all => [@EXPORT_OK]);

=head1 SYNOPSIS

This module provides basic set operations for native lists.  The primary goal
is to take advantage of Perl's native functional programming capabilities
while relying solely on Pure Perl constructs to perform the set operations as
fast as possible.  All of these techniques have been benchmarked against other
common Perl idioms to determine the optimal solution.  These benchmarks can
be found in this package (shortly).

Each function is provided in two forms.  The first form always expects simple
flat data structures of defined elements.  The second form expects a BLOCK
to evaluate each member of the list to a defined value to determine how the
element is a set member.  These can be identified by the suffix "_by".  None
of these functions check definedness inline so as to eliminate the costly
O(n) operation.  All functions have been prototyped to give them a native
Perl-ish look and feel.

Example usage:

	use Set::Functional ':all';

	my @deduped_numbers = setify(1 .. 10, 2 .. 11);
	my @deduped_objects_by_name = setify_by { $_->{name} } ({name => 'fred'}, {name => 'bob'}, {name => 'fred'});

	my @only_arr1_elements = difference \@arr1, \@arr2, \@arr3, \@arr4;
	my @only_arr1_elements_by_name = difference_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

	my @unique_per_set = disjoint \@arr1, \@arr2, \@arr3, \@arr4;
	my @unique_per_set_by_name = disjoint_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

	my @unique_elements = distinct \@arr1, \@arr2, \@arr3, \@arr4;
	my @unique_elements_by_name = distinct_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

	my @shared_elements = intersection \@arr1, \@arr2, \@arr3, \@arr4;
	my @shared_elements_by_name = intersection_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

	my @all_elements = union \@arr1, \@arr2, \@arr3, \@arr4;
	my @all_elements_by_name = union_by { $_->{name} } \@arr1, \@arr2, \@arr3, \@arr4;

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES

=head2 setify(@)

Given a list, return a new set.

=cut

sub setify(@) {
	my %set;

	undef @set{@_} if @_;

	return keys %set;
}

=head2 setify_by(&@)

Given a choice function and a list, return a new set defined by the choice function.

=cut

sub setify_by(&@){
	my $func = shift;

	my %set;

	@set{ map { $func->($_) } @_ } = @_ if @_;

	return values %set;
}

=head2 difference(@)

Given multiple set references, return a new set with all the elements in the first set
that don't exist in subsequent sets.

=cut

sub difference(@) {
	my $first = shift;

	return unless $first && @$first;

	my %set;

	undef @set{@$first};

	do { delete @set{@$_} if @$_ } for @_;

	return keys %set;
}

=head2 difference_by(&@)

Given a choice function and multiple set references, return a new set with all the elements
in the first set that don't exist in subsequent sets according to the choice function.

=cut

sub difference_by(&@) {
	my $func = shift;
	my $first = shift;

	return unless $first && @$first;

	my %set;

	@set{ map { $func->($_) } @$first } = @$first;

	do { delete @set{ map { $func->($_) } @$_ } if @$_ } for @_;

	return values %set;
}

=head2 disjoint(@)

Given multiple set references, return corresponding sets containing all the elements from
the original set that exist in any set exactly once.

=cut

sub disjoint(@) {
	my %element_to_count;

	do { ++$element_to_count{$_} for @$_ } for @_;

	return map { [grep { $element_to_count{$_} == 1 } @$_] } @_;
}

=head2 disjoint_by(&@)

Given a choice function and multiple set references, return corresponding sets containing
all the elements from the original set that exist in any set exactly once
according to the choice function.

=cut

sub disjoint_by(&@) {
	my $func = shift;

	my %key_to_count;

	do { ++$key_to_count{$func->($_)} for @$_ } for @_;

	return map { [grep { $key_to_count{$func->($_)} == 1 } @$_] } @_;
}

=head2 distinct(@)

Given multiple set references, return a new set containing all the elements that exist
in any set exactly once.

=cut

sub distinct(@) {
	my %element_to_count;

	do { ++$element_to_count{$_} for @$_ } for @_;

	return grep { $element_to_count{$_} == 1 } keys %element_to_count;
}

=head2 distinct_by(&@)

Given a choice function and multiple set references, return a new set containing all the
elements that exist in any set exactly once according to the choice function.

=cut

sub distinct_by(&@) {
	my $func = shift;

	my %key_to_count;

	for (@_) {
		for (@$_) {
			my $key = $func->($_);
			$key_to_count{$key} = exists $key_to_count{$key} ? undef : $_;
		}
	}

	return grep { defined } values %key_to_count;
}

=head2 intersection(@)

Given multiple set references, return a new set containing all the elements that exist
in all sets.

=cut

sub intersection(@) {
	my $first = shift;

	return unless $first && @$first;

	my %set;

	undef @set{@$first};

	for (@_) {
		my @int = grep { exists $set{$_} } @$_;
		return unless @int;
		undef %set;
		undef @set{@int};
	}

	return keys %set;
}

=head2 intersection_by(&@)

Given a choice function and multiple set references, return a new set containing all the
elements that exist in all sets according to the choice function.

=cut

sub intersection_by(&@) {
	my $func = shift;
	my $first = shift;

	return unless $first && @$first;

	my %set;

	@set{ map { $func->($_) } @$first } = @$first;

	for (@_) {
		my @int = grep { exists $set{$func->($_)} } @$_;
		return unless @int;
		undef %set;
		@set{ map { $func->($_) } @int } = @int;
	}

	return values %set;
}

=head2 union(@)

Given multiple set references, return a new set containing all the elements that exist
in any set.

=cut

sub union(@) {
	my %set;

	do { undef @set{@$_} if @$_ } for @_;

	return keys %set;
}

=head2 union_by(&@)

Given a choice function and multiple set references, return a new set containing all the
elements that exist in any set according to the choice function.

=cut

sub union_by(&@) {
	my $func = shift;

	my %set;

	do { @set{ map { $func->($_) } @$_ } = @$_ if @$_ } for @_;

	return values %set;
}

=head1 AUTHOR

Aaron Cohen, C<< <aarondcohen at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-set-functional at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Set-Functional>.  I will
be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 TODO

=over 4

=item * Add benchmarking scripts as mentioned above.

=item * Add the function cartesian.

=back

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Set::Functional

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Set-Functional>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Set-Functional>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Set-Functional>

=item * Search CPAN

L<http://search.cpan.org/dist/Set-Functional/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Aaron Cohen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Set::Functional
