package Gedcom::Date::Range;

use strict;

use vars qw($VERSION @ISA);

$VERSION = 0.01;
@ISA = qw/Gedcom::Date/;

use Gedcom::Date;
use Carp;

sub parse {
    my $class = shift;
    my ($str) = @_;

    my ($aft, $bef);
    if ($str =~ /^BET (.*?) AND (.*)$/) {
        $aft = Gedcom::Date::Simple->parse($1) or return;
        $bef = Gedcom::Date::Simple->parse($2) or return;
    } elsif ($str =~ /^AFT (.*)$/) {
        $aft = Gedcom::Date::Simple->parse($1) or return;
    } elsif ($str =~ /^BEF (.*)$/) {
        $bef = Gedcom::Date::Simple->parse($1) or return;
    } else {
        return;
    }

    my $self = bless {
        aft => $aft,
        bef => $bef
    }, $class;

    return $self;
}

sub gedcom {
    my $self = shift;

    if (!defined $self->{gedcom}) {
        if (defined($self->{aft}) && defined($self->{bef})) {
            $self->{gedcom} = 'BET ' . $self->{aft}->gedcom() .
                              ' AND ' . $self->{bef}->gedcom();
        } elsif (defined($self->{aft})) {
            $self->{gedcom} = 'AFT ' . $self->{aft}->gedcom();
        } else {
            $self->{gedcom} = 'BEF ' . $self->{bef}->gedcom();
        }
    }
    $self->{gedcom};
}

sub latest {
    my ($self) = @_;

    if ($self->{bef}) {
        return $self->{bef}->latest;
    } else {
        return DateTime::Infinite::Future->new;
    }
}

sub earliest {
    my ($self) = @_;

    if ($self->{aft}) {
        return $self->{aft}->earliest;
    } else {
        return DateTime::Infinite::Past->new;
    }
}

1;

__END__

=head1 NAME

Gedcom::Date::Range - Perl class for interpreting simple Gedcom dates

=head1 SYNOPSIS

  use Gedcom::Date::Range;

  my $date = Gedcom::Date::Range->parse(
                        'BET 10 JUL 2003 AND 20 AUG 2003' );

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
