import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  //const CustomButton({key}) : super(key: key);
  CustomButton(
      {@required this.text,
      this.backgroundColor = Colors.white,
      this.textColor = Colors.white,
        this.assetname,
      this.onPressed});
  final String text;
  String assetname;
  Color textColor;
  Color backgroundColor;
  VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed??(){},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(assetname != null)
            Image.asset(assetname, height: 25.0, width: 25.0,),
          Text(
            text,
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          if(assetname != null)
            Opacity(
            opacity: 0.0,
              child: Image.asset(assetname, height: 25.0, width: 25.0,)
          ),
        ],
      ),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(textColor),
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor)),
    );
  }
}
