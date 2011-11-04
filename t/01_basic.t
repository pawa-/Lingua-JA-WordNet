use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;

my $wn = Lingua::JA::WordNet->new('./wordnet/test.db');
isa_ok($wn, 'Lingua::JA::WordNet');
can_ok('Lingua::JA::WordNet', qw/Word Synset SynPos Rel Def Ex AllSynsets/);

done_testing;
