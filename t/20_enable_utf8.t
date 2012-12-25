use strict;
use warnings;
use utf8;
use Encode qw/encode_utf8/;
use Lingua::JA::WordNet;
use Test::More;


subtest 'enable_utf8' => sub {
    my $wn = Lingua::JA::WordNet->new(
        enable_utf8 => 1,
    );

    my @synsets = $wn->Synset('相撲', 'jpn');
    my @words = $wn->Word($synsets[0], 'jpn');
    is($words[0], '大相撲');

    my @exs = $wn->Ex('00810729-v', 'jpn');
    is($exs[0], '彼女は悪事を見つけられずにすませます！');
    is(length $exs[0], '19');
};

subtest 'disable_utf8' => sub {
    my $wn =Lingua::JA::WordNet->new;

    my @synsets = $wn->Synset('相撲', 'jpn');
    my @words = $wn->Word($synsets[0], 'jpn');
    is( $words[0], encode_utf8('大相撲') );

    my @exs = $wn->Ex('00810729-v', 'jpn');
    is( $exs[0], encode_utf8('彼女は悪事を見つけられずにすませます！') );
    cmp_ok(length $exs[0], '>', '19');
};

done_testing;
