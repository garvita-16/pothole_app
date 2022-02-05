import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/custom_widgets/show_alert_diag.dart';

Future<void> showExceptionAlertDiag(
  BuildContext context, {
    @required String title,
    @required Exception exception,
}) => showAlertDiag(
    context,
    title: title,
    content: _message(exception),
    DefaultActionText: 'Ok',
);

String _message(Exception exception) {
  if(exception is FirebaseAuthException){
    return exception.message;
  }
  return exception.toString();
}