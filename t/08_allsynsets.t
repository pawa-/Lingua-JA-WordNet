use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;

my $wn = Lingua::JA::WordNet->new('./wordnet/test.db');
my @allsynsets = $wn->AllSynsets;
is(scalar @allsynsets, 3);

done_testing;
