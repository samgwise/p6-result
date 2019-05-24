use v6.c;

#
# Common interface for Result objects
#

unit role Result::Any;

method ok(Str $err-msg) { ... }

method is-ok( --> Bool) { ... }

method is-err(--> Bool) { ... }

# Boolean behaviour for Result objects dispatches to their .is-ok status
method so( --> Bool) {
    self.is-ok
}

method Bool( --> Bool) {
    self.is-ok
}

# Util for use in with blocks, generalised implimentation:
method err-to-undef( --> Any) {
    return Any if self.is-err;
    self.ok("Error unwrapping ok value with .ok");
}