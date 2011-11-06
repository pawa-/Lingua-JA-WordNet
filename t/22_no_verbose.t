use strict;
use warnings;
use Lingua::JA::WordNet;
use Test::More;
use Test::Warn;

my $wn = Lingua::JA::WordNet->new(data => './wordnet/test.db', verbose => 0);
warning_is { $wn->Word('hogehoge', 'jpn') } '';
warning_is { $wn->Synset('fugafuga', 'jpn') } '';
warning_is { $wn->SynPos('karikari', 'n', 'jpn') } '';
warning_is { $wn->Rel('mofumofu', 'hype') } '';
warning_is { $wn->Def('peropero', 'jpn') } '';
warning_is { $wn->Ex('mochimochi', 'jpn') } '';
warning_is { $wn->Pos('fuwafuwa') } '';

$wn = Lingua::JA::WordNet->new('./wordnet/test.db');
warning_is { $wn->Word('hogehoge', 'jpn') } '';
warning_is { $wn->Synset('fugafuga', 'jpn') } '';
warning_is { $wn->SynPos('karikari', 'n', 'jpn') } '';
warning_is { $wn->Rel('mofumofu', 'hype') } '';
warning_is { $wn->Def('peropero', 'jpn') } '';
warning_is { $wn->Ex('mochimochi', 'jpn') } '';
warning_is { $wn->Pos('fuwafuwa') } '';

done_testing;
