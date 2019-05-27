#! /usr/bin/env perl6
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
