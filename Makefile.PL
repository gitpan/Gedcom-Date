use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'Gedcom::Date',
    VERSION_FROM => 'lib/Gedcom/Date.pm',
    AUTHOR       => 'Eugene van der Pijll (pijll@gmx.net)',
    ABSTRACT     => '',
    PREREQ_PM    => {
                     'Test::More' => 0,
                     'DateTime' => 0.15,
                     'Params::Validate' => 0,
                    },
);
