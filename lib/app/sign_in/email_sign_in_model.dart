import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/sign_in/validate.dart';

enum EmailSignInFormType {
  register,
  signIn
}
class EmailSignInModel  with EmailAndPasswordValidator {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formtype = EmailSignInFormType.signIn,
    this.isloading = false,
    this.issubmitted = false,
  }
  );
  String get primaryText{
    return formtype == EmailSignInFormType.signIn ? 'Sign in' : 'Register';
  }
  String get secondaryText{
    return formtype == EmailSignInFormType.signIn
        ? 'Need an account ? Register '
        : 'Have an account ? Sign in';
  }
  bool get canSubmit{
    return emailValidators.isValid(email) &&
        passwordValidators.isValid(password) &&
        !isloading;
  }
  String get passwordErrorText{
    bool passwordValid = issubmitted && !passwordValidators.isValid(password);
    return passwordValid ? passwordError : null;
  }
  String get emailErrorText{
    bool emailValid = issubmitted && !emailValidators.isValid(email);
    return emailValid ? emailError : null;
  }
  final String email;
  final String password;
  final EmailSignInFormType formtype;
  final bool isloading;
  final bool issubmitted;

  EmailSignInModel copywith({
    String email,
     String password,
    EmailSignInFormType formtype,
     bool isloading,
    bool issubmitted,
}){
    return EmailSignInModel(
      email: email ?? this.email,
      password : password ?? this.password,
      formtype : formtype ?? this.formtype,
      isloading: isloading ?? this.isloading,
      issubmitted: issubmitted ?? this.issubmitted,
    );
  }
}

