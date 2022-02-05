import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/admin/admin_show_report_details.dart';
import 'package:pothole_detection_app/app/custom_widgets/show_alert_diag.dart';
import 'package:pothole_detection_app/app/custom_widgets/show_exception_alert_diag.dart';
import 'package:pothole_detection_app/app/globals.dart';
import 'package:pothole_detection_app/app/models/report.dart';
import 'package:pothole_detection_app/app/services/auth.dart';
import 'package:pothole_detection_app/app/services/database.dart';
import 'package:pothole_detection_app/app/user/job_list_tile.dart';
import 'package:pothole_detection_app/app/user/list_item_builder.dart';
import 'package:pothole_detection_app/app/user/show_report_details.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatelessWidget {
  //const AdminPage({Key? key}) : super(key: key);


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
      emailSignIn=false;
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Admin Page'),
        backgroundColor: Color(0xff14DAE2),
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
      backgroundColor: Color(0xff251F34),

    );
  }
  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Report>>(
      stream: database.reportAllStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Report>(
          snapshot: snapshot,
          itemBuilder: (context, report) =>
              Dismissible(
                key: Key('report-${report.id}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => _delete(context, report),
                child: JobListTile(
                  report: report,
                  onTap: () => _showReport(context,report),
                ),
              ),
        );
      },
    );
  }

  Future<void> _delete(BuildContext context, Report report) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteReport(report);
    } on FirebaseException catch (e) {
      showExceptionAlertDiag(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _showReport(BuildContext context, Report report) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdminShowReportDetails(database: database, report: report),
        fullscreenDialog: true,
      ),
    );
  }
}
