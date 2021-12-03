
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/custom_widgets/custom_raised_widget.dart';

class FormSubmitButton extends CustomRaisedButton{
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
}) : super(
    child: Text(text,
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.white,
      ),
    ),
    color: Colors.indigo,
    height: 44.0,
    borderRadius: 4.0,
    onPressed: onPressed,
  );
}