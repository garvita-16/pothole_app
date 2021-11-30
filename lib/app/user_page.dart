
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/services/auth.dart';
import 'package:pothole_detection_app/app/sign_in/sign_in_with_phone.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
class UserPage extends StatelessWidget {
  //const AdminPage({Key? key}) : super(key: key);
  final _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
        elevation: 2.0,
      ),
      backgroundColor: Colors.grey[200],
      body:  _buildContainer(context),
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 48.0),
          RaisedButton(
            onPressed:()=> _signInWithGoogle(context),
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
  Widget _buildHeader() {
    if(_isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text('Sign in',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
        ));
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
}
