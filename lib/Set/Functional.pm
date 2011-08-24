package Set::Functional;

use 5.006;
use strict;
use warnings;

=head1 NAME

Set::Functional - The great new Set::Functional!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Set::Functional;

    my $foo = Set::Functional->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 setify(@)

=cut

sub setify(@) {
  my %set;
  undef @set{@_} if @_;

  return keys %set;
}

=head2 setify_by(&@)

=cut

sub setify_by(&@){
	my $func = shift;

	my %set;
	@set{ map { $func->($_) } @_ } = @_ if @_;

	return values %set;
}

=head2 difference(;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)

=cut

sub difference(;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@) {
  my $first = shift;

	return unless @$first;

  my %set;
  undef @set{@$first};

  do { delete @set{@$_} if @$_ } for @_;

  return keys %set;
}

=head2 difference_by(&;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)

=cut

sub difference_by(&;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@) {
	my $func = shift;
  my $first = shift;

	return unless @$first;

  my %set;
	@set{ map { $func->($_) } @$first } = @$first;

  do { delete @set{ map { $func->($_) } @$_ } if @$_ } for @_;

  return values %set;
}

=head2 distinct(;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)

=cut

sub distinct(;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@) {
	my %set;
	do { ++$set{$_} for @$_ } for @_;

	return grep { $set{$_} == 1 } keys %set;
}

=head2 distinct_by(&;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)

=cut

sub distinct_by(&;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@) {
	my $func = shift;

	my %set;
	for (@_) {
		for (@$_) {
			my $key = $func->($_);
			if (exists $set{$key}) { undef $set{$key} }
			else { $set{$key} = $_ }
		}
	}

	return grep { defined } values %set;
}

=head2 intersection(;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)

=cut

sub intersection(;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@) {
  my $first = shift;

	return unless @$first;

  my %set;
  undef @set{@$first};

  for (@_) {
    my @int = grep { exists $set{$_} } @$_;
    return unless @int;
    undef %set;
    undef @set{@int}
  }

  return keys %set;
}

=head2 intersection_by(&;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)

=cut

sub intersection_by(&;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@) {
	my $func = shift;
  my $first = shift;

	return unless @$first;

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

=head2 union(;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)

=cut

sub union(;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@) {
  my %set;
  do { undef @set{@$_} if @$_ } for @_;

  return keys %set;
}

=head2 union_by(&;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)

=cut

sub union_by(&;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@) {
	my $func = shift;

	my %set;
	do { $set{ map { $func->($_) } @$_ } = @$_ if @$_ } for @_;

	return values %set;
}

=head1 AUTHOR

Aaron Cohen, C<< <aarondcohen at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-set-functional at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Set-Functional>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




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


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Aaron Cohen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Set::Functional
