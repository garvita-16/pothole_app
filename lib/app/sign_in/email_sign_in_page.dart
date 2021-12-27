
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
        elevation: 0,
        leading: _goBackButton(context),
        backgroundColor: Color(0xff251F34),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: EmailSignInFormChangeNotifier.create(context) ,
            color: Color(0xfff3B324E),
          ),
        ),
      ),
      backgroundColor: Color(0xff251F34),
    );
  }


  Widget _goBackButton(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey[350]),
        onPressed: () {
          Navigator.of(context).pop(true);
        });
  }
}
