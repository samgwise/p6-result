use v6;
use Result::Ok;
use Result::Err;

module Result::Imports {
  sub OK($value, :$type --> Result::Ok)  is export {
    Result::Ok.new( :$value :$type )
  }

  sub Error(Str $error --> Result::Err) is export {
    Result::Err.new($error);
  }
}

sub EXPORT() {
  %(
    'Result::Ok'  => Result::Ok,
    'Result::Err' => Result::Err,
  )
}
