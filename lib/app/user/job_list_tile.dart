import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/models/report.dart';
class JobListTile extends StatelessWidget {
 // const JobListTile({Key? key}) : super(key: key);

  const JobListTile({Key key, @required this.report,@required this.onTap}) : super(key: key);
  final Report report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(report.id),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
