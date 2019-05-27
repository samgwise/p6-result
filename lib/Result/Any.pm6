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

#! Util for use in with blocks, generalised implimentation:
method err-to-undef( --> Any) {
    return Any if self.is-err;
    self
}

#
# Chaining methods
#

#! Calls the given Callable for Result::Err objects but just pass along a Result::Ok.
method map-err(&with-err --> Result::Any) {
    return self if self.is-ok;
    with-err(self)
}

#! Call the given Callable for Result::Ok objects but just pass along a Result::Err.
method map-ok(&with-ok --> Result::Any) {
    return self if self.is-err;
    with-ok(self)
}