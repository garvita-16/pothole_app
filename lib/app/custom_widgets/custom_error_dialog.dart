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
      builder: (context) => PlatformAlertDialog(
        title: Text(title),
        content: Text(message),
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
