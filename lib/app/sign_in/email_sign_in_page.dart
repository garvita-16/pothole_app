
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/sign_in/email_sign_in_change_notifier.dart';
import 'package:pothole_detection_app/app/sign_in/email_sign_in_change_notifier.dart';


class EmailSignInPage extends StatelessWidget {
  //const EmailSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: EmailSignInFormChangeNotifier.create(context) ,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
