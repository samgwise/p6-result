use v6.c;

#
# Common interface for Result objects
#

unit role Result::Any;

method ok(Str $err-msg) { ... }

has Bool $.is-ok;

has Bool $.is-err;

# Boolean behaviour for Result objects dispatches to their .is-ok status
method so( --> Bool) {
    $!is-ok
}

method Bool( --> Bool) {
    $!is-ok
}

#! Util for use in with blocks, generalised implementation:
method err-to-undef( --> Any) {
    return Any if self.is-err;
    self
}

#
# Chaining methods
#

#! Calls the given Callable for Result::Err objects but just passes along a Result::Ok.
method map-err(&with-err --> Result::Any) {
    return self if $!is-ok;
    with-err(self)
}

#! Call the given Callable for Result::Ok objects but just passesz along a Result::Err.
method map-ok(&with-ok --> Result::Any) {
    return self if $!is-err;
    with-ok(self)
}
