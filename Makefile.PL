use inc::Module::Install;

name 'Catalyst-Helper-Model-Email';
all_from 'lib/Catalyst/Helper/Model/Email.pm';

perl_version    '5.008';

requires 'Mail::Builder::Simple';
build_requires 'Catalyst::Runtime';
build_requires 'Test::More';
build_requires  'Test::Pod'             => 0;

WriteAll;
