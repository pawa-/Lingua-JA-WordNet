use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;
use Test::Warn;

my $wn = Lingua::JA::WordNet->new(
    data    => './wordnet/test.db',
    verbose => 1,
);

my @synsets = $wn->Synset('ミク', 'jpn');
is($synsets[0], '00000001-n');

warning_is { @synsets = $wn->Synset('Perl', 'jpn') }
    'Synset: no synsets for Perl in jpn', 'synset of unknown word';

is(scalar @synsets, 0);

done_testing;
