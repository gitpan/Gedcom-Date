# -*- perl -*-

# t/100_compare.t - compare dates

BEGIN{
    $^W = 1;
}

use Test::More tests => 1;
use Gedcom::Date;

my $gd1 = Gedcom::Date->parse( "10 JUL 2003" );
my $gd2 = Gedcom::Date->parse( "20 JUL 2003" );

ok( $gd1 < $gd2, 'Simple comparison' );
