package Gedcom::Date;

use strict;
use Carp;

use vars qw($VERSION);

$VERSION = 0.01;

use Gedcom::Date::Simple;
use Gedcom::Date::Period;
use Gedcom::Date::Range;
use Gedcom::Date::Approximated;
use Gedcom::Date::Interpreted;
use Gedcom::Date::Phrase;

use overload ( fallback => 1,
               '>'      => '_later_than',
               '<'      => '_earlier_than',
             );

sub parse {
    my $class = shift;

    my ($str) = @_;

    return
        Gedcom::Date::Period->parse($str) ||
        Gedcom::Date::Range->parse($str) ||
        Gedcom::Date::Approximated->parse($str) ||
        Gedcom::Date::Interpreted->parse($str) ||
        Gedcom::Date::Simple->parse($str) ||
        Gedcom::Date::Phrase->parse($str);
}

sub from_datetime {
    my ($class, $dt) = @_;

    return Gedcom::Date::Simple->from_datetime($dt);
}

sub _later_than {
    my ($self, $other, $switched) = @_;
    _earlier_than($other, $self) if $switched;

    return 1 if $self->earliest > $other->latest;
    return 0 if $self->latest < $other->earliest;
    return;
}

sub _earlier_than {
    my ($self, $other, $switched) = @_;
    _later_than($other, $self) if $switched;

    return 0 if $self->earliest > $other->latest;
    return 1 if $self->latest < $other->earliest;
    return;
}

1;

__END__

=head1 NAME

Gedcom::Date - Perl class for interpreting dates in Gedcom files

=head1 SYNOPSIS

  use Gedcom::Date;

  my $date = Gedcom::Date->parse( '10 JUL 2003' );

=head1 DESCRIPTION

Parse dates from Gedcom files.

=head1 METHODS

=over 4

=item * parse( $date )

Create a Gedcom::Date object from a string.

=item * earliest

Return the earliest possible date; e.g. for the date "BET 10 JUL 2003
AND 20 JUL 2003" it returns July 10, 2003. The value returned is a
DateTime object.

=item * latest

Return the latest possible date; e.g. for the date "BET 10 JUL 2003
AND 20 JUL 2003" it returns July 20, 2003. The value returned is a
DateTime object.

=back

=head1 AUTHOR

Eugene van der Pijll <pijll@gmx.net>

=head1 COPYRIGHT

Copyright (c) 2003 Eugene van der Pijll.  All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).

=cut
