use strict;
use warnings;
use GD::Tab::Guitar;

my $gtr = GD::Tab::Guitar->new();
$gtr->bgcolor(255, 255, 255);
$gtr->interlaced(0);

my $fname = $ARGV[0];
my $dirname = "$fname.data";
mkdir $dirname;

print <<_
<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="chord.css">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<span><a href="index.html">[powrót]</a></span>
<span><a href="#" onclick="print()">[drukuj]</a></span>
<pre>
_
;

my @lines;
my $title = <>;
chomp $title;

while (<>) {
  my $line = $_;
  if ($line =~ /^(.*): *([\dx]{6})/g) {
    my ($name, $how) = ($1, $2);
    my $fn = $name;
    $fn =~ s!/!-!g;
    open my $f, ">:raw", "$dirname/$fn.png";
    print $f $gtr->generate($name, $how)->png;
  } else {
    $line =~ s!(https?://.*)(?= |$)!<a href="$1">$1</a>!g;
    $line =~ s/((\s+|^)[CDEFGABH]#?(dim|m|maj|b|is|es)?(\d+)?\*?\+?(\/[CDEFGABH])?(?=\s+|$))/<span class="chord">$1<\/span>/gi;
    push @lines, $line;
  }
}

print qq(<div id="chords-section">);
for (glob "$dirname/*.png") {
  print qq(<span class="chord-image"><img src="$_" alt="[chord image for $_]" /></span>)
}
print qq(</div>);

print qq(
<span class="title"> $title </span>
<hr>
<div id="auto-scroll-opts"></div>
);

print for @lines;

print <<__
</pre>
<script defer src="scroll-chords.js"></script>
</body>
</html>
__
;
