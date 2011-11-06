use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;
use Test::Exception;

my $wn = Lingua::JA::WordNet->new('./wordnet/test.db');
isa_ok($wn, 'Lingua::JA::WordNet');
can_ok('Lingua::JA::WordNet', qw/Word Synset SynPos Pos Rel Def Ex AllSynsets/);
throws_ok { Lingua::JA::WordNet->new; } qr/WordNet data path is not set/;

done_testing;
