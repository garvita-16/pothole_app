import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/models/report.dart';
import 'package:pothole_detection_app/app/models/user.dart';
class LeaderboardListTile extends StatelessWidget {
 // const JobListTile({Key? key}) : super(key: key);

  const LeaderboardListTile({Key key, @required this.user}) : super(key: key);
  final UserData user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.firstName,style: TextStyle(fontSize: 18),),
      trailing: Text('Points: ${user.points}',style: TextStyle(fontSize: 18),),
    );
  }
}
