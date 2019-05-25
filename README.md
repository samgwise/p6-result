[![Build Status](https://travis-ci.org/samgwise/p6-result.svg?branch=master)](https://travis-ci.org/samgwise/p6-result)

Result
======

Result - Encapsulate the result of a computation.

SYNOPSIS
========

Result is a simple module which provides some tools for returning values from a function and signaling to the caller if the function succeded or failed. Results are an explicitly returned encapsulation and therefore have to be used to access the return of a function, in contrast to a perl6 Failure which is invisible unless there is a problem.

The synopsis below demonstrates handling a Result and just unwrapping it and accepting the exception if it's an Result::Err.

```perl6
use Result;

# A routine which returns an Err or an Ok result
sub schrödinger-roulette(Str $cat-name --> Result::Any) {
  given (0, 1).pick {
    when 0 {
      Ok "{ $cat-name.tc } is alive!"
    }
    when 1 {
      Err "{ $cat-name.tc } is no more."
    }
  }
}

# managed errors
given schrödinger-roulette("Dutches") {
  when Result::Ok {
    say .value
  }
  when Result::Err {
    say "Oh no! { .error } Let's give it another go...";
  }
}

# Unmanaged errors
schrödinger-roulette("O'Mally")
  .ok("Perhaps we shouldn't be playing this game...")
  .say;
```

DESCRIPTION
===========

Result is inspired by Rust's Result enum. It provides an error management framework similar to Perl6's Failures, but with stricter semantics. This is by no means a one to one port, but it does attempt to provide the core essentials of this pattern.

With the Result patttern, all values returned from a function are a Result type, either an OK or an Err. To obtain the value returned by the function you can choose to dispatch the error yourself or call the `ok(Str)` method. The `ok(Str)` method simply returns the value if it is called on a `Result::Ok` object. However if it is called on a Result::Err object the error will be thrown. The message passed via `ok(Str)` method and the message from the `Result::Err` will be included in the Exception, providing both function and call specific error messages.

The value of a `Result::Ok` message may have a type check applied to it. If there is a violation of the constraint an exception will be thrown.

See Also
========

The perl6 `Failure` constructs provide slightly different approach for solving the same problem, be sure to consider if they might be a better fit for your needs. For more, see: [https://docs.perl6.org/language/control#fail](https://docs.perl6.org/language/control#fail)

Changes
=======

head
====

0.2.2

  * Added `.err-to-undef` to facilitate use of Result values in `with` blocks.

0.2.0
-----

Major braking changes!

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

Creates a Result::Err with the given message. The message is readable from the ``.error` attribute.

