use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;
use Test::Warn;

my $wn = Lingua::JA::WordNet->new(
    data    => './wordnet/test.db',
    verbose => 1,
);

my @exs = $wn->Ex('00000002-n', 'jpn');
is($exs[0], 'るかるかにする');
is($exs[1], '動画投稿サイトでタコのようなルカを見た');
is(scalar @exs, 2);

warning_is { @exs = $wn->Ex('12345678-v', 'eng') }
    'Ex: no examples for 12345678-v in eng',
    'examples of unknown synset';

is(scalar @exs, 0);

done_testing;
