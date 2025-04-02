class State<T> {
  final T? value;
  final String? message;

  State({this.value, this.message});

  @override
  String toString() {
    return 'State{value: $value, message: $message}';
  }
}

class Success<T> extends State<T> {
  Success(value) : super(value: value);
}

class GenericError<T> extends State<T> {
  GenericError(message) : super(message: message);
}

class NoInternet<T> extends State<T> {
  NoInternet(message) : super(message: message);
}


class UserExists<T> extends State<T> {}

class UserNotFound<T> extends State<T> {}

class InvalidLoginCredentials<T> extends State<T> {}

class UserExitsForSignUp<T> extends State<T> {}

class TransactionEmptyError<T> extends State<T> {}
