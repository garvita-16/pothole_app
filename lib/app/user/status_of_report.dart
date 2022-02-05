import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/custom_widgets/show_alert_diag.dart';
import 'package:pothole_detection_app/app/custom_widgets/show_exception_alert_diag.dart';
import 'package:pothole_detection_app/app/models/report.dart';
import 'package:pothole_detection_app/app/services/auth.dart';
import 'package:pothole_detection_app/app/services/database.dart';
import 'package:pothole_detection_app/app/user/job_list_tile.dart';
import 'package:pothole_detection_app/app/user/list_item_builder.dart';
import 'package:pothole_detection_app/app/user/show_report_details.dart';
import 'package:provider/provider.dart';
import '../../landing_page.dart';


class StatusOfReport extends StatelessWidget {
  //const HomePage({Key? key}) : super(key: key);

  const StatusOfReport({Key key,@required this.database}) : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StatusOfReport(database: database),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Color(0xff14DAE2),
      ),
      body: _buildContents(context),
      backgroundColor: Color(0xff251F34),
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<Report>>(
      stream: database.reportStream(),
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
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShowReportDetails(database: database, report: report),
        fullscreenDialog: true,
      ),
    );
  }

}

