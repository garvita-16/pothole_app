import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pothole_detection_app/app/custom_widgets/custom_error_dialog.dart';
import 'package:pothole_detection_app/app/custom_widgets/show_alert_diag.dart';
import 'package:pothole_detection_app/landing_page.dart';

import '../home_page.dart';

abstract class AuthBase {
  User get currentUser;
  Stream<User> authStateChanges();
  Future<void> signOut();
  Future<User> signInWithGoogle();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> loginUserUsingPhone(String phone, BuildContext context);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  final _codeController = TextEditingController();
  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async {
    final userCredentials = await _firebaseAuth.signInAnonymously();
    return userCredentials.user;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final UserCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return UserCredential.user;
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredentials = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredentials.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in ABORTED BY USER',
      );
    }
  }


  @override
  Future<void> loginUserUsingPhone(String phone, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    dynamic userCredential = null;
    auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        try {
          userCredential = await _firebaseAuth.signInWithCredential(credential);
        }
        catch(e)
        {
          print(e.toString());
          CustomErrorDialog.show(
              context: context,
              title: 'Error',
              message: e.toString());
        }
      },
      verificationFailed: (FirebaseAuthException exception) {
        print(exception.toString());
      },
      codeSent: (String verificationId, [int forecResendingToken]) {
        showPlatformDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Give the code',style: TextStyle(color: Colors.white)),
                backgroundColor: Color(0xff251F34),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _codeController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Otp',
                        labelStyle: TextStyle(color: Colors.white)
                      ),
                    )
                  ],
                ),
                actions: [
                  FlatButton(
                    onPressed: () async {
                      try {
                        final code = _codeController.text.trim();
                        final credential = PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: code);
                        userCredential = await _firebaseAuth.signInWithCredential(credential);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                      catch(e)
                      {
                        Navigator.of(context).pop();
                        CustomErrorDialog.show(
                            context: context,
                            title: 'Invalid Otp',
                            message: 'Try again');
                      }
                    },
                    child: Text('confirm',
                        style: TextStyle(color: Colors.white, fontSize: 15.0)),
                    color: Color(0xff14DAE2),
                  )
                ],
              );
            });
      },
      // codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
    );
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
