use utf8;
use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;

my $wn = Lingua::JA::WordNet->new(
    data        => './wordnet/test.db',
    enable_utf8 => 1,
);

my ($synset) = $wn->Synset('ボカロ', 'jpn');
my ($ex)     = $wn->Ex($synset, 'jpn');
is($ex, 'ボカロ買ったけど挫折した');

done_testing;
