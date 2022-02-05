import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomErrorDialog {
  static show({
    String title = 'title',
    String message = 'message',
    @required BuildContext context,
    List<Widget> actions,
  }) {
    return showPlatformDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: Text(title, style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Color(0xff251F34),
        content: Text(message, style: TextStyle(
          color: Colors.white,
        ),),
        actions: actions ?? <Widget>[
          PlatformDialogAction(
            child: PlatformText('OK'),
            onPressed: Navigator.of(context).pop,
          ),
        ],
      ),
    );
  }
}
