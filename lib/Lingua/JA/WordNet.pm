package Lingua::JA::WordNet;

use 5.008_001;
use strict;
use warnings;

use Carp ();
use DBI;

our $VERSION = '0.04';


sub new
{
    my $class = shift;
    my %args;

    if (scalar @_ == 1) { $args{data} = shift; }
    else                { %args       = @_;    }

    Carp::croak "WordNet data path is not set" if !    $args{data};
    Carp::croak "WordNet data is not found"    if ! -e $args{data};

    $args{enable_utf8} = 0 if !exists $args{enable_utf8}; # default is 0
    $args{verbose}     = 0 if !exists $args{verbose};     # default is 0

    my $dbh = DBI->connect("dbi:SQLite:dbname=$args{data}", "", "", {
        Warn           => 0, # get rid of annoying disconnect message
        RaiseError     => 1,
        PrintError     => 0,
        AutoCommit     => 0,
        sqlite_unicode => $args{enable_utf8},
    });

    bless { dbh => $dbh, verbose => $args{verbose} }, $class;
}

sub Word
{
    my ($self, $synset, $lang) = @_;

    my $sth
        = $self->{dbh}->prepare
        (
            'SELECT lemma FROM word JOIN sense ON word.wordid = sense.wordid
              WHERE synset     = ?
                AND sense.lang = ?'
        );

    $sth->execute($synset, $lang);

    my @words = map { $_->[0] =~ s/_/ /go; $_->[0]; } @{$sth->fetchall_arrayref};

    Carp::carp "Word: no words for $synset in $lang" if $self->{verbose} && !scalar @words;

    return @words;
}

sub Synset
{
    my ($self, $word, $lang) = @_;

    my $sth
        = $self->{dbh}->prepare
        (
            'SELECT synset FROM word LEFT JOIN sense ON word.wordid = sense.wordid
              WHERE lemma      = ?
                AND sense.lang = ?'
        );

    $sth->execute($word, $lang);

    my (@synsets, $synset);

    $sth->bind_columns( \($synset) );

    while ($sth->fetchrow_arrayref)
    {
        push(@synsets, $synset);
    }

    Carp::carp "Synset: no synsets for $word in $lang" if $self->{verbose} && !scalar @synsets;

    return @synsets;
}

sub SynPos
{
    my ($self, $word, $pos, $lang) = @_;

    my $sth
        = $self->{dbh}->prepare
        (
            'SELECT synset FROM word LEFT JOIN sense ON word.wordid = sense.wordid
              WHERE lemma      = ?
                AND word.pos   = ?
                AND sense.lang = ?'
        );

    $sth->execute($word, $pos, $lang);

    my (@synsets, $synset);

    $sth->bind_columns( \($synset) );

    while ($sth->fetchrow_arrayref)
    {
        push(@synsets, $synset);
    }

    Carp::carp "SynPos: no synsets for $word in $lang with pos: $pos" if $self->{verbose} && !scalar @synsets;

    return @synsets;
}

sub Pos
{
    my ($self, $synset) = @_;
    return $1 if $synset =~ /^\d\d\d\d\d\d\d\d-([arnv])$/o;
    Carp::carp "Pos: $synset is wrong synset format" if $self->{verbose};
    return;
}

sub Rel
{
    my ($self, $synset, $rel) = @_;

    my $sth
        = $self->{dbh}->prepare
        (
            'SELECT synset2 FROM synlink
              WHERE synset1 = ?
                AND link    = ?'
        );

    $sth->execute($synset, $rel);

    my @synsets = map {$_->[0]} @{$sth->fetchall_arrayref};

    Carp::carp "Rel: no $rel links for $synset" if $self->{verbose} && !scalar @synsets;

    return @synsets;
}

sub Def
{
    my ($self, $synset, $lang) = @_;

    my $sth
        = $self->{dbh}->prepare
        (
            'SELECT sid, def FROM synset_def
              WHERE synset = ?
                AND lang   = ?'
        );

    $sth->execute($synset, $lang);

    my (@defs, $sid, $def);

    $sth->bind_columns( \($sid, $def) );

    while ($sth->fetchrow_arrayref)
    {
        $defs[$sid] = $def;
    }

    Carp::carp "Def: no definitions for $synset in $lang" if $self->{verbose} && !scalar @defs;

    return @defs;
}

sub Ex
{
    my ($self, $synset, $lang) = @_;

    my $sth
        = $self->{dbh}->prepare
        (
            'SELECT sid, def FROM synset_ex
              WHERE synset = ?
                AND lang   = ?'
        );

    $sth->execute($synset, $lang);

    my (@exs, $sid, $ex);

    $sth->bind_columns( \($sid, $ex) );

    while ($sth->fetchrow_arrayref)
    {
        $exs[$sid] = $ex;
    }

    Carp::carp "Ex: no examples for $synset in $lang" if $self->{verbose} && !scalar @exs;

    return @exs;
}

sub AllSynsets
{
    my $self = shift;
    my $sth = $self->{dbh}->prepare('SELECT synset FROM synset');
    $sth->execute;
    my @synsets = map {$_->[0]} @{$sth->fetchall_arrayref};
    return @synsets;
}

1;
__END__

=encoding utf8

=head1 NAME

Lingua::JA::WordNet - Perl OO interface to Japanese WordNet database

=for test_synopsis
my ($db_path, %config, $synset, $lang, $pos, $rel);

=head1 SYNOPSIS

  use Lingua::JA::WordNet;

  my $wn = Lingua::JA::WordNet->new('wnjpn-1.1.db');
  my @synsets = $wn->Synset('相撲', 'jpn');
  my @hypes   = $wn->Rel($synsets[0], 'hype');
  my @words   = $wn->Word($hypes[0], 'jpn');

  print "$words[0]\n";
  # -> レスリング

=head1 DESCRIPTION

Japanese WordNet is a semantic dictionary of Japanese.
Lingua::JA::WordNet is yet another Perl module to look up
entries in Japanese WordNet.

The original Perl module is WordNet::Multi.
WordNet::Multi is awkward to use and not maintained.
Because of this, I uploaded this module.

=head1 METHODS

=over 4

=item new($db_path) or new(%config)

Creates a new Lingua::JA::WordNet instance.

  my $wn = Lingua::JA::WordNet->new(
      data        => $db_path, # default is undef
      enable_utf8 => 1,        # default is 0 (see sqlite_unicode attribute of DBD::SQLite)
      verbose     => 0,        # default is 0 (all warnings are ignored)
  );

The data must be Japanese WordNet and English WordNet in an SQLite3 database.
(Please download it from http://nlpwww.nict.go.jp/wn-ja)


=item Word($synset, $lang)

Returns the words corresponding to $synset and $lang.

=item Synset($word, $lang)

Returns the synsets corresponding to $word and $lang.

=item SynPos($word, $pos, $lang)

Returns the synsets corresponding to $word, $pos and $lang.

=item Pos($synset)

Returns the part of speech of $synset.

=item Rel($synset, $rel)

Returns the relational synsets corresponding to $synset and $rel.

=item Def($synset, $lang)

Returns the definition sentences corresponding to $synset and $lang.

=item Ex($synset, $lang)

Returns the example sentences corresponding to $synset and $lang,

=item AllSynsets()

Returns all synsets.


=back


=head2 LANGUAGES

The values which can be set to $lang are 'jpn' and 'eng'.


=head2 PARTS OF SPEECH

The values which can be set to $pos are left side values of the following table.

  a|adjective
  r|adverb
  n|noun
  v|verb
  a|形容詞
  r|副詞
  n|名詞
  v|動詞

This is the result of SQLite3 command 'SELECT pos, def FROM pos_def'.


=head2 RELATIONS

The values which can be set to $rel are left side values of the following table.

  also|See also
  syns|Synonyms
  hype|Hypernyms
  inst|Instances
  hypo|Hyponym
  hasi|Has Instance
  mero|Meronyms
  mmem|Meronyms --- Member
  msub|Meronyms --- Substance
  mprt|Meronyms --- Part
  holo|Holonyms
  hmem|Holonyms --- Member
  hsub|Holonyms --- Substance
  hprt|Holonyms -- Part
  attr|Attributes
  sim|Similar to
  enta|Entails
  caus|Causes
  dmnc|Domain --- Category
  dmnu|Domain --- Usage
  dmnr|Domain --- Region
  dmtc|In Domain --- Category
  dmtu|In Domain --- Usage
  dmtr|In Domain --- Region
  ants|Antonyms

This is the result of SQLite3 command 'SELECT link, def FROM link_def'.


=head1 AUTHOR

pawa E<lt>pawapawa@cpan.orgE<gt>

=head1 SEE ALSO

Japanese WordNet E<lt>http://nlpwww.nict.go.jp/wn-jaE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
