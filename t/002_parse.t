# -*- perl -*-

# t/002_parse.t - parse dates

BEGIN{
    $^W = 1;
}

use Test::More tests => 28;
use Gedcom::Date;

foreach my $str (<DATA>) {
    chomp $str;
    $d = Gedcom::Date->parse($str);
    isa_ok( $d, 'Gedcom::Date', $str );
    is($d->gedcom, $str, "parsed $str");
}

__DATA__
10 JUL 2003
JUL 2003
2003
ABT 10 JUL 2003
CAL 10 JUL 2003
EST 10 JUL 2003
FROM 10 JUL 2003
TO 10 JUL 2003
FROM 10 JUL 2003 TO 20 JUL 2003
AFT 10 JUL 2003
BEF 10 JUL 2003
BET 10 JUL 2003 AND 20 JUL 2003
INT 10 JUL 2003 (foo)
(foo)
