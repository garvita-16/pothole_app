import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/services/auth.dart';
import 'package:pothole_detection_app/app/user/report_pothole.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/show_alert_diag.dart';

class HomePage extends StatelessWidget {
  //const HomePage({Key? key}) : super(key: key);

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
         RaisedButton(
             onPressed: (){},
           child: Text('LeaderBoard',style: TextStyle(
             fontSize: 15.0,
             color: Colors.black,
           ),),
           color: Colors.white,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.all(
               Radius.circular(8.0),
             ),
           ),
         ),
          SizedBox(height: 8.0),
          RaisedButton(
            onPressed:()=> ReportPothole.show(context),
            child: Text('Report Pothole',style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          RaisedButton(
            onPressed: (){},
            child: Text('Status of Report',style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),),
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

  void _reportPothole(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder:(context)=> ReportPothole(),
        )
    );
  }

}
