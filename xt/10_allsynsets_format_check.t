use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;

my $wn = Lingua::JA::WordNet->new;

my @allsynsets = $wn->AllSynsets;

for my $synset (@allsynsets)
{
    like($synset, qr/^[0-9]{8}-[arnv]$/, 'format check');
}

done_testing;
