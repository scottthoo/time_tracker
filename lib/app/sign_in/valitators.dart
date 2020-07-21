abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValitator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValitator();
  final StringValidator passwordValidator = NonEmptyStringValitator();
  final String invalidEmailErrorText = 'Email can\'t be empty';
  final String invalidPasswordErrorText = 'Password can\'t be empty';
}
