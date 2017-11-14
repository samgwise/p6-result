
role A {
  has $.a
}

class B does A {
  method b { $!a }
}

class C does A {
  method c { $!a.lc }
}

role D does A {
  method d { 'd' }
}

sub test(A $v) {
  say $v.a
}

my $a = A.new( :a('A') );
my $b = B.new( :a('B') );
my $c = C.new( :a('C') );
my $d = D.new;
for $a, $b, $c {
  say "testing { .a }";
  test $_
}

say "D accepts A { D ~~ A }";
say "A accepts D { A ~~ D }";
say "D accepts D { D ~~ D }";
