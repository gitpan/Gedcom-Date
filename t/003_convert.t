# -*- perl -*-

# t/003_parse.t - covert to/from datetimes

BEGIN{
    $^W = 1;
}

use Test::More tests => 2;
use Gedcom::Date;
use DateTime;

my $dt = DateTime->new( year => 2003, month => 7, day => 18 );
my $gd = Gedcom::Date->from_datetime( $dt );

isa_ok($gd, 'Gedcom::Date');
is($gd->gedcom, '18 JUL 2003');
