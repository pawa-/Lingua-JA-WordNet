use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;
use Test::Warn;

my $wn = Lingua::JA::WordNet->new(
    data    => './wordnet/test.db',
    verbose => 1,
);

my @synsets = $wn->SynPos('ルカ', 'n', 'jpn');
is($synsets[0], '00000002-n');

warning_is { @synsets = $wn->SynPos('Perl', 'n', 'jpn') }
    'SynPos: no synsets for Perl in jpn with pos: n', 'synpos of unknown word';

is(scalar @synsets, 0);

done_testing;
