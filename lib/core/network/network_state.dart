class State<T> {
  final T? value;
  final Exception? exception;

  State({this.value, this.exception});

  @override
  String toString() {
    return 'State{value: $value, exception: $exception}';
  }
}

class Success<T> extends State<T> {
  Success(value) : super(value: value);
}

class GenericError<T> extends State<T> {
  GenericError(exception) : super(exception: exception);
}

class NoInternet<T> extends State<T> {
  NoInternet(exception) : super(exception: exception);
}


class UserExists<T> extends State<T> {}

class UserNotFound<T> extends State<T> {}

class InvalidLoginCredentials<T> extends State<T> {}

class UserExitsForSignUp<T> extends State<T> {}

class TransactionEmptyError<T> extends State<T> {}
