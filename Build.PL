use Module::Build;

Module::Build -> new
(
	module_name		=> 'Gedcom::Date',
	license			=> 'artistic',
	dist_author		=> 'Eugene van der Pijll (pijll@gmx.net)',
	build_requires	=>
	{
		Test::More	=> 0,
	},
	requires		=>
	{
		DateTime	     => 0.15,
		Params::Validate => 0,
	},
) -> create_build_script();
