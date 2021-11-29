import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/user_page.dart';
import 'package:provider/provider.dart';

import 'app/services/auth.dart';

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
          RaisedButton(
              onPressed:(){},
            child: Text(
                'Sign in as admin',
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
            onPressed: ()=> _userSignIn(context),
            child: Text(
              'Sign in/Sign up as User',
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

  void _userSignIn(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder:(context)=> UserPage(),
        )
    );
  }
}
