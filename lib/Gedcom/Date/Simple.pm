package Gedcom::Date::Simple;

use strict;

use vars qw($VERSION @ISA);

$VERSION = 0.01;
@ISA = qw/Gedcom::Date/;

use Gedcom::Date;
use DateTime;
use Carp;

my %months = (
    GREGORIAN => [qw/JAN FEB MAR APR MAI JUN JUL AUG SEP OCT NOV DEC/],
);

sub parse_datetime {
    my ($class, $str) = @_;

    my ($cal, $date) =
        $str =~ /^(?:\@#(\w+)\@\s+)?(.+)$/
        or return;  # Not a simple date

    $cal ||= 'GREGORIAN';
    return unless exists $months{$cal};

    my ($d, $month, $y) =
        $date =~ /^(?:(?:(\d+)\s+)?(\w+)\s+)(\d+)$/
        or return;

    $d ||= 1;   # Handling of incomplete dates is not correct yet
    $month ||= $months{$cal}[0];

    my $m;
    for (0..$#{$months{$cal}}) {
        $m = $_+1 if $month eq $months{$cal}[$_];
    }
    defined($m) or return;

    my $dt = DateTime->new( year => $y, month => $m, day => $d )
        or return;

    return $dt;
}

sub parse {
    my $class = shift;
    my ($str) = @_;

    my $dt = Gedcom::Date::Simple->parse_datetime($str)
        or return;

    my $self = bless {
        datetime => $dt,
    }, $class;

    return $self;
}

sub gedcom {
    my $self = shift;

    if (!defined $self->{gedcom}) {
        my $str = uc $self->{datetime}->strftime('%d %b %Y');
        $str =~ s/\b0+(\d)/$1/g;
        $self->{gedcom} = $str;
    }
    $self->{gedcom};
}

sub from_datetime {
    my ($class, $dt) = @_;

    return bless {
               datetime => $dt,
           }, $class;
}

sub latest {
    my ($self) = @_;

    return $self->{datetime};
}

sub earliest {
    my ($self) = @_;

    return $self->{datetime};
}

1;

__END__

=head1 NAME

Gedcom::Date::Simple - Perl class for interpreting simple Gedcom dates

=head1 SYNOPSIS

  use Gedcom::Date::Simple;

  my $date = Gedcom::Date->parse( '10 JUL 2003' );

=head1 DESCRIPTION

Parse dates from Gedcom files.

=head1 AUTHOR

Eugene van der Pijll <pijll@gmx.net>

=head1 COPYRIGHT

Copyright (c) 2003 Eugene van der Pijll.  All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

L<Gedcom::Date>,

perl(1).

=cut
