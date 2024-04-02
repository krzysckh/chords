#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 2; -*-

use strict;
use warnings;
use feature 'say';

my $PDFJAM = "/root/pdfjam/bin/pdfjam";
my @cpdf_names;

sub createpdf() {
  my $s = join " ", map {"'" . $_ . ".txt'" } @cpdf_names;
  print "chords.ps ...";
  `cat $s | u2ps -w - > chords.ps`;
  say "\rchords.ps OK";
  print "chords.pdf ...";
  `pdf2ps chords.ps chords.pdf`;
  say "\rchords.pdf OK";
}

sub should($$) {
  my ($nam, $T) = @_;
  return 1 if ! -e "$nam.$T";
  open my $txt, "$nam.txt" or die;
  open my $pdf, "$nam.$T" or die;

  my @s1 = stat $txt;
  my @s2 = stat $pdf;

  my ($d1, $d2) = ($s1[9], $s2[9]);

  close $txt;
  close $pdf;

  return $d1 > $d2
}

sub basename ($) {
  my ($f) = @_;
  $f =~ s/^(.*)\..*$/$1/;

  return $f
}

sub getn ($) {
  my ($real) = @_;
  open my $ff, "<", "$real.txt";
  my $friendly = <$ff>;
  close $ff;
  $friendly =~ s/^\s+//;
  chomp $friendly;

  return $friendly;
}

open my $f, ">", "index.html" or die;
my @files = map { basename $_ } glob "*.txt";
my @names = map { getn $_ } @files;

my %h;

for (@names) {
  $h{$_} = shift @files;
}

print $f <<_
<html>
<head>
<meta charset="utf-8">
<link href="chord.css" rel="stylesheet">
</head>
<body>
<ul>
_
;

for (sort { lc($a) cmp lc($b) } keys %h) {
  my $friendly = $_;
  my $real = $h{$friendly};
  push @cpdf_names, $real;

  if (should($real, "html") or ! -e "$real.txt.data") {
    print "$real html ...";
    `perl crd2html.pl '$real.txt' < $real.txt > $real.html`; # if ! -f "$real.html"; # yeah just re-make everything
    say "\r$real html OK";
  }

  if (should($real, "pdf")) {
    print "$real pdf ...";
    `u2ps -w - < $real.txt | ps2pdf - > $real.pdf`;
    say "\r$real pdf OK";
  }

  print $f qq!<li class="song"><span class="idx-title">$friendly</span>
  <a href="$real.html">[HTML]</a> <a href="$real.txt">[TEXT]</a></li>!;
}

print $f <<__
</ul>
<span>
  <a href="https://www.perl.org/"><img alt="powered by perl" src="powered_by_perl.gif"></a>
  <a href="http://plan9.stanleylieber.com/mothra/"><img src="https://pub.krzysckh.org/mothracompat.gif" alt="mothra compatible"></a>
</span>
<script src="fuzzysort.js"></script>
<script defer src="search.js"></script>
</body>
</html>
__
;

close $f;
say "INDEX OK";

createpdf;

say "FULL PDF OK";
