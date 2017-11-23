use v6;
use Result;

class Result::Err does Result {

  has Str $.error;

  method ok(Str:D $local-message) {
    die ($local-message, $!error)
      .join("\n")
  }

  method is-ok( --> Bool) {
    False
  }

  method is-err(--> Bool) {
    True
  }
}
