use v6;
use Result;

class Result::Err does Result is Exception {

  has Str $.error;
  has Str $!local-err;

  # Implementing for Exception
  method message( --> Str) {
    qq:to/ERR/.chomp
    $!error
    $!local-err
    ERR
  }

  method ok(Str $local-message) {
    if $!is-okeyed {
      warn "The ok method has already been called on this result, this will likely cause unpredictable behaviour!";
      self.throw
    }
    else {
      $!local-err = $local-message;
      $!is-okeyed = True;
      self.throw;
    }
  }

  method is-ok( --> Bool) {
    False
  }

  method is-err(--> Bool) {
    True
  }
}
