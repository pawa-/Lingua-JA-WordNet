use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;

my $wn = Lingua::JA::WordNet->new;
my @allsynsets = $wn->AllSynsets;
is(scalar @allsynsets, 117659, 'num of all synsets');
like($allsynsets[0], qr/^[0-9]{8}-[arnv]$/, 'synset format');

done_testing;
