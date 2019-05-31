#! /usr/bin/env perl6
use Result;

# An example function for attempting a conversion of a value to an Int.
# This function can return two outcomes.
# An Ok outcome with either an Int or something whcih accepts .Int or otherwise an Err.
sub to-int(Any $val --> Result::Any) {
    return Ok $val if $val ~~ Int;
    try return Ok $val.Int;
    Err "Unable to convert value of type { $val.WHAT.perl } to Int."
}

# To get the result of the conversion you have to access it via the returned Result object.
my @test-values = "Not an Int", 7, "42", Any, pi;
for @test-values -> $val {
    given to-int($val) {
        when .is-ok { say "{ $val.WHAT.perl } $val converted to Int { .value }" }
        when .is-err { say "Well that wasn't an Int: { .error }" }
    }
}

# If you want an exception on error but the value otherwise you can use .ok
say 'The numeral 3 is an Int' ~ to-int('3').ok('Unable to convert value to Int');

try {
    CATCH { 
        default { say .gist }
    }
    say 'My asciimote is an Int: ' ~ to-int('<3').ok('No, even asciimotes are not an Int!');
}

# You can also use a with block via the .err-to-undef adapter method.
for @test-values -> $val {
    with to-int($val).err-to-undef {
        say "{ $val.WHAT.perl } $val converted to Int { .value }"
    }
    else {
        say "Well '{ $val.gist }' wasn't an Int"
    }

}

# Lasty if in doubt, you can wrap any code with a result block to wrap any exceptions or failures to results.
# Oh and results will also be returned as is so don't worry if you mix things up!
for <die fail smile other> {
    my $val = result {
        when 'die'   { die 'boom' }
        when 'fail'  { fail 'bang' }
        when 'smile' { Ok '☺' }
        default      { '★' }
    }

    say "$_ => { $val.WHAT.gist } with value: { $val.map-err( { Ok .error } ).value }";
}