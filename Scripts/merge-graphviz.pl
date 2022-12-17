use strict;
sub main {
  local $/ = undef;
  print "digraph {\n";
  for my $f (@ARGV) {
    open(F, $f) or die $!;
    my $text = <F>;
    close(F);
    $text =~ s/digraph/subgraph/;
    $text =~s/^/  /mg;
    print $text;
  }
  print "}\n";
}

main;