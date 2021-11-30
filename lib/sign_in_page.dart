import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/user_page.dart';
import 'package:provider/provider.dart';

import 'app/services/auth.dart';
import 'app/sign_in/sign_in_with_phone.dart';
import 'landing_page.dart';

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
      ),
      backgroundColor: Colors.grey[200],
      body:  _buildContainer(context),
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 40.0,
            child: Text('Sign in as admin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                )
            ),
          ),
          SizedBox(height: 8.0),
          RaisedButton(
              onPressed:(){},
            child: Text(
                'Sign in with Email',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          SizedBox(
            height: 50.0,
            child: Text('Sign in/Sign up as user',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                )),
          ),
          SizedBox(height: 8.0),
          RaisedButton(
            onPressed: ()=> _signInWithGoogle(context),
            child: Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          RaisedButton(
            onPressed:()=> _signInWithPhoneNumber(context),
            child: Text(
              'Sign in with Phone Number',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _signInWithGoogle(BuildContext context) async{
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.signInWithGoogle();
    } on Exception catch(e){
      print(e.toString());
    }
  }
  void _signInWithPhoneNumber(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder:(context)=> SignInWithPhone(),
        )
    );
  }

  // void _userSignIn(BuildContext context) {
  //   final auth = Provider.of<AuthBase>(context, listen: false);
  //   Navigator.of(context).push(
  //       MaterialPageRoute<void>(
  //         fullscreenDialog: true,
  //         builder:(context)=> UserPage(),
  //       )
  //   );
  // }

}
