import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pothole_detection_app/app/custom_widgets/form_submit_button.dart';
import 'package:pothole_detection_app/app/custom_widgets/show_exception_alert_diag.dart';
import 'package:pothole_detection_app/app/services/auth.dart';
import 'package:provider/provider.dart';

import 'email_sign_in_change_model.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  //const EmailSignInForm({Key? key}) : super(key: key);}
  EmailSignInFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  EmailSignInChangeModel get model => widget.model;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _emailFocusNode() {
    final newFocus = model.emailValidators.isValid(model.email)
        ? _passwordFocus
        : _emailFocus;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDiag(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _toggleForm() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      Text('Sign in',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
        ),),
      SizedBox(height: 25.0),
      _buildEmailTextField(),
      SizedBox(height: 25.0),
      _buildPasswordTextField(),
      SizedBox(height: 25.0),
      FormSubmitButton(
        text: model.primaryText,
        onPressed: model.canSubmit
            ? _submit
            : () {
          print("null");
          print(model.email);
          print(model.password);
          print(!model.isloading);
        },

        //onPressed: _submit,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(
          model.secondaryText,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: !model.isloading ? _toggleForm : null,
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      style: (TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400
      )),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        errorText: model.passwordErrorText,
        enabled: model.isloading == false,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff14DAE2), width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        prefixIcon: Image.asset('images/icon_lock.png'),
      ),

      obscureText: true,
      cursorColor: Colors.white,
      controller: _passwordController,
      focusNode: _passwordFocus,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isloading == false,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff14DAE2), width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        prefixIcon: Image.asset('images/icon_email.png'),
      ),
      controller: _emailController,
      focusNode: _emailFocus,
      cursorColor: Colors.white,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailFocusNode(),
      onChanged: model.updateEmail,
      style: (TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

}
