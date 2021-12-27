import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/custom_widgets/custom_button.dart';
import 'package:pothole_detection_app/app/globals.dart';
import 'package:provider/provider.dart';

import 'app/services/auth.dart';
import 'app/sign_in/email_sign_in_page.dart';
import 'app/sign_in/sign_in_with_phone.dart';

class SignInPage extends StatefulWidget {
  //const LandingPage({Key? key}) : super(key: key);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Pothole App'),
        backgroundColor: Color(0xff14DAE2),
      ),
      backgroundColor: Color(0xff251F34),
      body: _buildContainer(context),
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 40.0,
            child: Text('Sign in as admin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                )),
          ),
          const SizedBox(height: 8.0),
          CustomButton(
            text: 'Sign in with Email',
            onPressed: ()=>_signInWithEmail(context),
            backgroundColor: Color(0xfff3B324E),
          ),
          const SizedBox(height: 20.0),
          const SizedBox(
            height: 50.0,
            child: Text('Sign in/Sign up as user',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                )),
          ),
          const SizedBox(height: 8.0),
          CustomButton(
            text: 'Sign in with Google',
            backgroundColor:Color(0xfff3B324E), //Color(0xfff3B324E),
            onPressed: () => _signInWithGoogle(context),
          ),
          const SizedBox(height: 8.0),
          CustomButton(
            text: 'Sign in with Phone Number',
            backgroundColor: Color(0xfff3B324E),
            onPressed: () => _signInWithPhoneNumber(context),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.signInWithGoogle();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void _signInWithPhoneNumber(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => SignInWithPhone(),
    ));
  }

  void _signInWithEmail(BuildContext context){
    setState(() {
      emailSignIn = true;
    });
    final auth = Provider.of<AuthBase>(context, listen: false);
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => EmailSignInPage(),
        )
    );
  }
}


