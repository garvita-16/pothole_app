import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:pothole_detection_app/app/custom_widgets/custom_button.dart';
import 'package:pothole_detection_app/app/services/auth.dart';
import 'package:pothole_detection_app/app/services/database.dart';
import 'package:pothole_detection_app/app/user/leaderboard.dart';
import 'package:pothole_detection_app/app/user/report_pothole.dart';
import 'package:pothole_detection_app/app/user/status_of_report.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/custom_error_dialog.dart';
import 'custom_widgets/show_alert_diag.dart';
import 'models/user.dart';

class HomePage extends StatelessWidget {

  final _passCodeController = TextEditingController();
  final _nameController = TextEditingController();
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignout = await showAlertDiag(context,
        title: 'Logout',
        content: 'Are you sure you want to logout',
        DefaultActionText: 'Logout',
        cancelActionText: 'Cancel');
    if (didRequestSignout == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        elevation: 2.0,
        actions: [
          FlatButton(
              child: Text('Logout',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  )),
              onPressed: () {
                return _confirmSignOut(context);
              } //_confirmSignOut(context),
              )
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => Leaderboard.show(context),
            child: Text(
              'LeaderBoard',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: () => ReportPothole.show(context),
            child: Text(
              'Report Pothole',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: () => StatusOfReport.show(context),
            child: Text(
              'Status of Report',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
          ),
          SizedBox(height: 70.0),
          ElevatedButton(
            onPressed: ()=> _becomeAnAdmin(context),
            child: Text(
              'Become an Admin',
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.black,
              ),
            ),
             style: ElevatedButton.styleFrom(
               primary: Colors.yellow,
               shadowColor: Colors.black,
             ),

          ),
        ],
      ),
    );
  }


 void _becomeAnAdmin(BuildContext context) {
   showPlatformDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           title: Text('Give the Passcode'),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               TextField(
                 controller: _passCodeController,
                 decoration: InputDecoration(
                   labelText: 'PassCode',
                 ),
               )
             ],
           ),
           actions: [
             ElevatedButton(
               onPressed: () async {
                 final code = _passCodeController.text.trim();
                 Navigator.of(context, rootNavigator: true).pop();
                 // if(code == 'GARVITA') {
                 //   return showPlatformDialog(
                 //     context: context,
                 //     builder: (context) => PlatformAlertDialog(
                 //       title: Text('You have become an Admin'),
                 //       actions: [
                 //         PlatformDialogAction(
                 //           child: PlatformText('OK'),
                 //           onPressed: Navigator.of(context).pop,
                 //
                 //         ),
                 //       ],
                 //     ),
                 //   );
                 // }
                 if(code == 'GARVITA'){
                   print("success");
                   Database database = Provider.of<Database>(context, listen: false);
                   UserData user = await database.getUser();
                   if(user!= null && user.firstName != null){
                     print("successssssss");
                     UserData _updatedUser=UserData(
                       firstName: user.firstName,
                       points: user.points,
                       isAdmin: true,
                     );
                     await database.setUser(_updatedUser);
                   }
                   else{
                     return showPlatformDialog(
                       context: context,
                       builder: (context) => PlatformAlertDialog(
                         title: Text('Enter your name'),
                         content: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             TextField(
                               controller: _nameController,
                               decoration: InputDecoration(
                                 labelText: 'Name',
                               ),
                             )
                           ],
                         ),
                         actions: [
                           FlatButton(
                             onPressed: () async {
                               try {
                                 UserData newUser=UserData(
                                   firstName: _nameController.text,
                                   points: 0,
                                   isAdmin: true,
                                 );
                                 await database.setUser(newUser);
                                 Navigator.of(context).pop();

                               }
                               catch(e)
                               {
                                 print(e.toString());
                                 Navigator.of(context).pop();
                               }
                             },
                             child: Text('ok',
                                 style: TextStyle(color: Colors.white, fontSize: 15.0)),
                             color: Colors.indigo,
                           )
                         ],
                       ),
                     );
                   }
                 }
                 else{
                   return showPlatformDialog(
                     context: context,
                     builder: (context) => PlatformAlertDialog(
                       title: Text('Wrong PassCode'),
                       actions: [
                         PlatformDialogAction(
                           child: PlatformText('OK'),
                           onPressed:  Navigator.of(context).pop,
                         ),
                       ],
                     ),
                   );
                 }
               },
               child: Text('confirm',
                   style: TextStyle(color: Colors.white, fontSize: 15.0)),
             ),
           ]
           ,
         );
       });
  }
}
