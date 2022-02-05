import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/services/auth.dart';
import 'package:pothole_detection_app/app/sign_in/email_sign_in_model.dart';
import 'package:pothole_detection_app/app/sign_in/validate.dart';

class EmailSignInChangeModel  with EmailAndPasswordValidator , ChangeNotifier{
  EmailSignInChangeModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formtype = EmailSignInFormType.signIn,
    this.isloading = false,
    this.issubmitted = false,
  }
  );
  final AuthBase auth;
  String email;
  String password;
   EmailSignInFormType formtype;
  bool isloading;
  bool issubmitted;

  Future<void> submit() async{
    updatewith(isloading: true, issubmitted: true);
    try {
      if (formtype == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      }
      else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch(e){
      rethrow;
    } finally{
      updatewith(isloading: false);
    }
  }
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

  void toggleFormType(){
    updatewith(
      email: '',
      password: '',
      formtype: this.formtype == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn,
      issubmitted: false,
      isloading: false,
    );
  }

  void updateEmail(String email){
    updatewith(email: email);
  }
  void updatePassword(String password){
    updatewith(password: password);
  }
  void updatewith({
    String email,
     String password,
    EmailSignInFormType formtype,
     bool isloading,
    bool issubmitted,
}){
      this.email = email ?? this.email;
      this.password = password ?? this.password;
      this.formtype = formtype ?? this.formtype;
      this.isloading = isloading ?? this.isloading;
      this.issubmitted = issubmitted ?? this.issubmitted;
      notifyListeners();
  }
}

