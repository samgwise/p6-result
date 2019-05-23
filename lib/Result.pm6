use v6.c;

=begin pod

=head1 Result

Result - Functional error handling ala Rust.

=head1 SYNOPSIS

=begin code :lang<perl6>

use Result;
use Result::Imports;

sub schrödinger-roulette(Str $cat-name --> Result) {
  given (0, 1).pick {
    when 0 {
      OK "{ $cat-name.tc } is alive!", :type(Str)
    }
    when 1 {
      Error( "{ $cat-name.tc } is no more." )
    }
  }
}

# dispatching errors without throwing
given schrödinger-roulette("Dutches") {
  when Result::Ok {
    say .value
  }
  when Result::Err {
    say "Oh no! { .error } Let's give it another go...";
  }
}

# throw on errors
schrödinger-roulette("O'Mally")
  .ok("Perhaps we shouldn't be playing this game...")
  .say;

=end code

=head1 DESCRIPTION

Result is inspired by Rust's Result enum.
It provides an error management framework similar to Perl6's Failures, but with stricter semantics.
This is by no means a one to one port, but it does attempt to provide the core essentials of this pattern.

With the Result patttern, all values returned from a function are a Result type, either an OK or an Err.
To obtain the value returned by the function you can choose to dispatch the error yourself or call the C<ok(Str)> method.
The C<ok(Str)> method simply returns the value if it is called on a C<Result::Ok> object.
However if it is called on a Result::Err object the error will be thrown.
The message passed via C<ok(Str)> method and the message from the C<Result::Err> will be included in the Exception, providing both function and call specific error messages.

The value of a C<Result::Ok> message may have a type check applied to it.
If there is a violation of the constraint an exception will be thrown.

=head1 See Also

The perl6 failure constructs provide slightly different approach for solving the same problem, be sure to consider if they might be a better fit for your needs.

=head1 AUTHOR

Sam Gillespie <samgwise@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Sam Gillespie

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

unit module Result:ver<0.2.0>;
use Result::Any;
use Result::Ok;
use Result::Err;

sub Ok($value --> Result::Ok) is export {
    Result::Ok.new(:$value)
}

sub Err(Str $error --> Result::Err) is export {
    Result::Err.new(:$error);
}

# Define rexport of sub modules
sub EXPORT() {
  %(
    'Result::Ok'  => ::Result::Ok,
    'Result::Err' => ::Result::Err,
    'Result::Any' => ::Result::Any,
  )
}