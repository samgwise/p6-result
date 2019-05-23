use v6;
use Result::Any;

class Result::Ok does Result::Any {
  has Any $.value;

  method ok(Str $) {
    $!value;
  }

  method is-ok( --> Bool) {
    True
  }

  method is-err( --> Bool) {
    False
  }
}
