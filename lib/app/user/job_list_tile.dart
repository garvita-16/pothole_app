import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/models/report.dart';
class JobListTile extends StatelessWidget {
 // const JobListTile({Key? key}) : super(key: key);

  const JobListTile({Key key, @required this.report,@required this.onTap}) : super(key: key);
  final Report report;
  final VoidCallback onTap;

  String idToDate(String reportId)
  {
    String dd=reportId.substring(8,10);
    String mm=reportId.substring(5,7);
    String yyyy=reportId.substring(0,4);
    return dd+'/'+mm+'/'+yyyy;
  }
  String idToTime(String reportId)
  {
    String time=reportId.substring(11,19);
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: report.isPothole? Colors.greenAccent:Colors.redAccent,
      title: Text('Date - '+idToDate(report.id)+' -----> '+statusToString(report.status),
        style: TextStyle(color: Colors.white),),
      subtitle: Text('Time - '+idToTime(report.id), style: TextStyle(color: Colors.white),),
      trailing: Icon(Icons.chevron_right, color: Colors.white,),
      onTap: onTap,
    );
  }
}
