[![Build Status](https://travis-ci.org/samgwise/p6-result.svg?branch=master)](https://travis-ci.org/samgwise/p6-result)

Result
======

Result - Encapsulate the result of a computation.

SYNOPSIS
========

Result is a simple module which provides some tools for returning values from a function and signaling to the caller if the function succeded or failed. Results are an explicitly returned encapsulation and therefore have to be used to access the return of a function, in contrast to a perl6 Failure which is invisible unless there is a problem.

The synopsis below demonstrates handling a Result and just unwrapping it and accepting the exception if it's an Result::Err.

```perl6
# examples/synopsis2.p6

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
```

DESCRIPTION
===========

Result was originally inspired by Rust's Result enum, but Perl 6 is a rather different languages and as such while the core conecpt remains, the implimentation and features are distinct. The Result module provides an error management framework similar to Perl6's Failures, but with stricter semantics.

The error handling pattern provided by the Result module trys to make it as clear as possible to the consumer of a function, that the function can return an error and therefore the consumer must take responsability for handling an error case. Therfore all values returned from a function, for which success is not certain, are of the `Result::Any` type, either an OK or an Err. Hence to obtain the value returned by the function you can choose to dispatch the error yourself with the following methods:

  * `.is-ok`

  * `.is-err`

  * `.map-ok`

  * `.map-err`

Or if you just want to fail on error, call the `.ok(Str)` method. The `.ok(Str)` method simply returns the value if it is called on a `Result::Ok` object. However if it is called on a Result::Err object the error will be thrown.

Mapping Results
---------------

There are two methods provided in the `Result::Any` interface for chaining computations together depending on the result.

  * `.map-err(&code --> Result::Any)`

  * `.map-ok(&code --> Result::Any)`

These routines call the provided `Callable` if their `is-*` identity is `True` and otherwise will simply skip the `Callable` and return the result object as is. The first argument to the `Callable` will be the result object which is being mapped. Be sure to return a result object else you will end up throwing an excepetion.

Interfaceing with core Perl 6 error handling
--------------------------------------------

The idententy methods, `.is-*` work well with the <given when> pattern but the `with` pattern depends on the definedness of the topic. An instace of Result::Any is defined (although an Err is Falsy and a Ok is Trueish), so to use a result object in a with block, use the `.err-to-undef` method (See the synopsis for an example).

If you want to adapt existing perl6 code to return an appropriate `Result::Any` value, use the `result` sub (See the synopsis for an example and below for more detail).

See Also
========

The perl6 `Failure` constructs provide a slightly different approach for solving the core problem of returning error state from functions or methods. Be sure to consider if they might be a better fit for your needs. For more on Failures, see: [https://docs.perl6.org/language/control#fail](https://docs.perl6.org/language/control#fail).

Changes
=======

head
====

0.2.4

Contributed by [JJ](https://github.com/JJ)

  * Type constraint on `Result::Ok.value` attributes relaxed.

  * Internal refactoring of `.is-ok` and `.is-err` from methods to attributes.

  * Cleaned up documentation

head
====

0.2.3

  * Added result sub which wraps any exceptions, failures into results for a given Callable. Result:Err and Result::Ok objects are passed on without any alteration.

  * Added .map-err and .map-ok methods to the Result::Any role allowing for type dependent chaining of handlers for result objects.

0.2.2
-----

  * Added `.err-to-undef` to facilitate use of Result values in `with` blocks.

0.2.0
-----

Major braking changes! Either specify a version tag or you can try the migration script: [migrate-0.1.0-to-0.2.0.p6](https://github.com/samgwise/p6-result/blob/master/tools/migrate-0.1.0-to-0.2.0.p6).

  * Result role renamed Result::Any - use this instead in signitures.

  * All result objects and helpers are exported with `use Result;`. Multiple imports are no longer required.

  * Result::Err is no longer a Failure object. This fixes throwing of exceptions when requesting an error message from a Result::Err object which happens in newer version of Rakudo.

  * Result::OK renamed to Result::Ok. The nameing is now more consistent and feels better.

  * Factory routine Error renamed Err. More consistent nameing.

  * Factory routine OK renamed Ok. More consistent nameing. Lowercase was considered but it clashes to easily with the Test module so leading case naming was maintained for factory routines.

  * Type constraining of Result::Ok payloads removed as I have not encoutered a useful application of this feature whle using the Result module.

0.1.0
-----

Initial release of Result module. Result:Err objects are Failures and do the Result role. Experimental type constraining of Result::OK object payloads.

AUTHOR
======

Sam Gillespie <samgwise@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2019 Sam Gillespie

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

### sub Ok

```perl6
sub Ok(
    $value
) returns Result::Ok
```

Creates a Result::OK containing the given value. To extract the payload, after checking with `*.is-ok` or `* ~~ Result::OK`, you can read the `.value` attribute.

### sub Err

```perl6
sub Err(
    Str $error
) returns Result::Err
```

Creates a Result::Err with the given message. The message is readable from the `.error` attribute.

### sub result

```perl6
sub result(
    &code
) returns Result::Any
```

Wraps the returned value of a `Callable` in a `Result::OK` and returns exceptions as a `Result::Err`. Returned failures are also transformed into `Result::Err` objects. If a `Result::Any` value is returned from the `Callable` it will be transperently passed along.

