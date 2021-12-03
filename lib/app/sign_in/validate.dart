abstract class StringValidate {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidate{
  @override
  bool isValid(String value){
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidator{
  final StringValidate emailValidators = NonEmptyStringValidator();
  final StringValidate passwordValidators = NonEmptyStringValidator();
  final emailError = 'email can\'t be empty';
  final passwordError = 'Password can\'t be empty';
}
