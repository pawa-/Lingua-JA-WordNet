use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;
use Test::Warn;

my $wn = Lingua::JA::WordNet->new('./wordnet/test.db');

my @words = $wn->Word('00000001-n', 'jpn');
is($words[0], 'ミク');

warning_is { @words = $wn->Word('3939-miku', 'negi') }
    'Word: no words for 3939-miku in negi', 'word of unknown synset';

is(scalar @words, 0);

done_testing;
