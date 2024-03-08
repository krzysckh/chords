#!/usr/bin/perl

use strict;
use warnings;

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

  `perl crd2html.pl '$real.txt' < $real.txt > $real.html` # if ! -f "$real.html"; # yeah just re-make everything
  ;

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
print "OK\n";
