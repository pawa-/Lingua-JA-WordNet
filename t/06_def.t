use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;
use Test::Warn;

my $wn = Lingua::JA::WordNet->new('./wordnet/test.db');

my @defs = $wn->Def('00000001-n', 'jpn');
is($defs[0], '緑色のツインテールの女の子');
is($defs[1], 'ネギを装備している');
is(scalar @defs, 2);

warning_is { @defs = $wn->Def('12345678-v', 'eng') }
    'Def: no definitions for 12345678-v in eng',
    'definitions of unknown synset';

is(scalar @defs, 0);

done_testing;
