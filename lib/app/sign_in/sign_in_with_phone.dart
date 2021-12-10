
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pothole_detection_app/app/custom_widgets/custom_error_dialog.dart';
import 'package:pothole_detection_app/app/services/auth.dart';
import 'package:provider/provider.dart';
class SignInWithPhone extends StatefulWidget {
  //const SignInWithPhone({Key? key}) : super(key: key);

  @override
  _SignInWithPhoneState createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  bool isLoading = false;

  final _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Sign in'),
      ),
      body: _buildContainer(context),
      backgroundColor: Colors.grey[200],
    );
  }
  Widget _buildContainer(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }
  Widget _buildForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
  List<Widget> _buildChildren() {
    return [
    TextField(

      decoration: InputDecoration(
        labelText: 'Phone Number',
        enabled: isLoading == false,
      ),
      //initialValue: _name,
      //onSaved: (value) => _name = value,
      //focusNode: _nameFocus,
      //onEditingComplete: _changeFocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      controller: _phoneController,
    ),
      SizedBox(height: 16.0),
      FlatButton(
          onPressed: () async {
            final auth = Provider.of<AuthBase>(context, listen: false);
            final String phone = '+91' +  _phoneController.text;
            if(phone.length==13) {
              await auth.loginUserUsingPhone(phone, context);
            }
            else
              {
                CustomErrorDialog.show(context: context,title: 'Incorrect Phone',message: 'Phone number should be 10 digits');
              }
          },
          child: Text('Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
          ),
        color: Colors.indigo,
      )
    ];
  }


}
