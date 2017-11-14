use v6;

subset IntOrStr where Int|Str;

sub test(IntOrStr $t --> IntOrStr) {
  $t
}

# Expected to work
say test(1);
say test('foo');

# Expected to fail
say test(2.3);
