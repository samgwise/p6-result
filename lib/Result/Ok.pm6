use v6;
use Result::Any;

class Result::Ok does Result::Any {
    has Any $.value;

    submethod TWEAK() {
        $!is-ok = True;
    }

  method ok(Str $) {
    $!value;
  }

  method is-err( --> Bool) {
    False
  }
}
