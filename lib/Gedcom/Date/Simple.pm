package Gedcom::Date::Simple;

use strict;

use vars qw($VERSION @ISA);

$VERSION = 0.03;
@ISA = qw/Gedcom::Date/;

use Gedcom::Date;
use DateTime 0.15;

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
        $date =~ /^(?:(?:(\d+)\s+)?(\w+)\s+)?(\d+)$/
        or return;

    my %known = ( d => defined $d, m => defined $month, y => 1 );
    $d ||= 1;   # Handling of incomplete dates is not correct yet
    $month ||= $months{$cal}[0];

    my $m;
    for (0..$#{$months{$cal}}) {
        $m = $_+1 if $month eq $months{$cal}[$_];
    }
    defined($m) or return;

    my $dt = DateTime->new( year => $y, month => $m, day => $d )
        or return;

    return $dt, \%known;
}

sub parse {
    my $class = shift;
    my ($str) = @_;

    my ($dt, $known) = Gedcom::Date::Simple->parse_datetime($str)
        or return;

    my $self = bless {
        datetime => $dt,
        known => $known,
    }, $class;

    return $self;
}

sub gedcom {
    my $self = shift;

    if (!defined $self->{gedcom}) {
        $self->{datetime}->set(locale => 'en');
        my $str;
        if ($self->{known}{d}) {
            $str = uc $self->{datetime}->strftime('%d %b %Y');
        } elsif ($self->{known}{m}) {
            $str = uc $self->{datetime}->strftime('%b %Y');
        } else {
            $str = $self->{datetime}->strftime('%Y');
        }
        $str =~ s/\b0+(\d)/$1/g;
        $self->{gedcom} = $str;
    }
    $self->{gedcom};
}

sub from_datetime {
    my ($class, $dt) = @_;

    return bless {
               datetime => $dt,
               known => {d => 1, m => 1, y => 1},
           }, $class;
}

sub latest {
    my ($self) = @_;

    my $dt = $self->{datetime};
    if (!$self->{known}{d}) {
        $dt->truncate(to => 'month')
           ->add(months => 1)
           ->subtract(days => 1);
    } elsif (!$self->{known}{m}) {
        $dt->truncate(to => 'year')
           ->add(years => 1)
           ->subtract(days => 1);
    }

    return $dt;
}

sub earliest {
    my ($self) = @_;

    my $dt = $self->{datetime};
    if (!$self->{known}{d}) {
        $dt->truncate(to => 'month');
    } elsif (!$self->{known}{m}) {
        $dt->truncate(to => 'year');
    }

    return $dt;
}

my %text = (
    en => ['on %0', 'in %0', 'in %0'],
    nl => ['op %0', 'in %0', 'in %0'],
);

sub text_format {
    my ($self, $lang) = @_;

    if ($self->{known}{d}) {
        return ($text{$lang}[0], $self);
    } elsif ($self->{known}{m}) {
        return ($text{$lang}[1], $self);
    } else {
        return ($text{$lang}[2], $self);
    }
}

sub _date_as_text {
    my ($self, $locale) = @_;

    my $dt = $self->{datetime};
    $dt->set(locale => $locale);

    if ($self->{known}{d}) {
        return $dt->strftime($dt->locale->long_date_format);
    } elsif ($self->{known}{m}) {
        return $dt->strftime('%B %Y');
    } else {
        return $dt->year;
    }
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
