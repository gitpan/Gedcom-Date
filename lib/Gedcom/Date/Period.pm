package Gedcom::Date::Period;

use strict;

use vars qw($VERSION @ISA);

$VERSION = 0.01;
@ISA = qw/Gedcom::Date/;

use Gedcom::Date;
use Carp;

sub parse {
    my $class = shift;
    my ($str) = @_;

    my ($from, $to);
    if ($str =~ /^FROM (.*?) TO (.*)$/) {
        $from = Gedcom::Date::Simple->parse($1) or return;
        $to = Gedcom::Date::Simple->parse($2) or return;
    } elsif ($str =~ /^FROM (.*)$/) {
        $from = Gedcom::Date::Simple->parse($1) or return;
    } elsif ($str =~ /^TO (.*)$/) {
        $to = Gedcom::Date::Simple->parse($1) or return;
    } else {
        return;
    }

    my $self = bless {
        from => $from,
        to => $to
    }, $class;

    return $self;
}

sub gedcom {
    my $self = shift;

    if (!defined $self->{gedcom}) {
        $self->{gedcom} = join ' ',
                          map {defined $self->{$_} ?
                               (uc, $self->{$_}->gedcom()) :
                               ()
                              }
                          qw/from to/;
    }
    $self->{gedcom};
}

1;

__END__

=head1 NAME

Gedcom::Date::Period - Perl class for interpreting simple Gedcom dates

=head1 SYNOPSIS

  use Gedcom::Date::Period;

  my $date = Gedcom::Date::Period->parse(
                        'FROM 10 JUL 2003 TO 20 AUG 2003' );

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
