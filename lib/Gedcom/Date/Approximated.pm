package Gedcom::Date::Approximated;

use strict;

use vars qw($VERSION @ISA);

$VERSION = 0.03;
@ISA = qw/Gedcom::Date/;

use Gedcom::Date;

sub parse {
    my $class = shift;
    my ($str) = @_;

    my ($abt, $date) = $str =~ /^(ABT|CAL|EST) (.*)$/
        or return;

    my $date_s = Gedcom::Date::Simple->parse($date)
        or return;

    my $self = bless {
        date => $date_s,
        abt => $abt
    }, $class;

    return $self;
}

sub gedcom {
    my $self = shift;

    if (!defined $self->{gedcom}) {
        $self->{gedcom} = $self->{abt} . ' ' . $self->{date}->gedcom();
    }
    $self->{gedcom};
}

sub latest {
    my ($self) = @_;

    return $self->{date}->latest;
}

sub earliest {
    my ($self) = @_;

    return $self->{date}->earliest;
}

my %text = (
    en => 'about %0',
    nl => 'rond %0',
);

sub text_format {
    my ($self, $lang) = @_;

    return ($text{$lang}, $self->{date});
}

1;

__END__

=head1 NAME

Gedcom::Date::Approximated - Perl class for approximated Gedcom dates

=head1 SYNOPSIS

  use Gedcom::Date::Approximated;

  my $date = Gedcom::Date::Approximated->parse( 'ABT 10 JUL 2003' );

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
