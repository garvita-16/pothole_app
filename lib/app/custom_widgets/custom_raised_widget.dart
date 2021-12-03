import 'package:flutter/material.dart';
class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    this.child, //= Text(
      //'Sign in with Google',
      //style: TextStyle(
       // color: Colors.black87,
        //fontSize: 15.0,
     // ),
    //),
    this.color, //= Colors.black87,
    this.borderRadius : 8.0, //= 4.0,
    this.height : 50,
    this.onPressed, //= null,
  });
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final dynamic onPressed;
  //const CustomRaisedButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
