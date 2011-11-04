use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;
use Test::Warn;

my $wn = Lingua::JA::WordNet->new('./wordnet/test.db');

my @hypes = $wn->Rel('00000001-n', 'hype');
is($hypes[0], '00000003-n');

@hypes = $wn->Rel('00000002-n', 'hype');
is($hypes[0], '00000003-n');

warning_is { @hypes = $wn->Rel('00000003-n', 'hype') }
    'Rel: no hype links for 00000003-n', 'rel of unknown synset';


my @hypos = $wn->Rel('00000003-n', 'hypo');

for my $hypo (@hypos)
{
    like($hypo, qr/0000000[12]-n/);
}

done_testing;
