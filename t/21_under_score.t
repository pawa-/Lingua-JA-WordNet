use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;

my $wn = Lingua::JA::WordNet->new('./wordnet/test.db');
my ($word) = $wn->Word('00000004-a', 'eng');
is($word, 'full delica'); # nipaa

done_testing;
