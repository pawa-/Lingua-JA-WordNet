use inc::Module::Install;

name     'Lingua-JA-WordNet';
all_from 'lib/Lingua/JA/WordNet.pm';

requires      'Carp';
requires      'DBI';
requires      'DBD::SQLite' => 1.27; # sqlite_unicode
test_requires 'Test::More'  => 0.88; # done_testing
test_requires 'Test::Warn';
test_requires 'Test::Exception';

tests 't/*.t';
author_tests 'xt';

readme_from 'lib/Lingua/JA/WordNet.pm';

resources(
    license    => 'http://dev.perl.org/licenses',
    repository => 'https://github.com/pawa-/Lingua-JA-WordNet',
    bugtracker => 'https://github.com/pawa-/Lingua-JA-WordNet/issues',
);

WriteAll;
