use v6;
use Result::Any;

class Result::Err does Result::Any {
  has Str $.error is required;
  
  submethod TWEAK() {
        $!is-ok = False;
  }
  
  method ok(Str:D $local-message) {
    die ".ok called on Result::Err: $local-message\n{ $!error.indent(4) }"
  }

  method is-err( --> Bool) {
    True
  }
}
