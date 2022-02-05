import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/custom_widgets/show_alert_diag.dart';
import 'package:pothole_detection_app/app/custom_widgets/show_exception_alert_diag.dart';
import 'package:pothole_detection_app/app/models/report.dart';
import 'package:pothole_detection_app/app/models/user.dart';
import 'package:pothole_detection_app/app/services/auth.dart';
import 'package:pothole_detection_app/app/services/database.dart';
import 'package:pothole_detection_app/app/user/job_list_tile.dart';
import 'package:pothole_detection_app/app/user/leaderboard_list_tile.dart';
import 'package:pothole_detection_app/app/user/list_item_builder.dart';
import 'package:pothole_detection_app/app/user/show_report_details.dart';
import 'package:provider/provider.dart';
import '../../landing_page.dart';


class Leaderboard extends StatelessWidget {
  //const HomePage({Key? key}) : super(key: key);

  const Leaderboard({Key key,@required this.database}) : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Leaderboard(database: database),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Color(0xff14DAE2),
      ),
      body: _buildContents(context),
      backgroundColor: Color(0xff251F34),
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<UserData>>(
      stream: database.userStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<UserData>(
          snapshot: snapshot,
          itemBuilder: (context, userData) {
            if(userData.firstName!=null) {
              return Dismissible(
                key: Key('user-${userData.firstName}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                child: LeaderboardListTile(
                  user: userData,
                ),
              );
            }
            else
              {
                return const SizedBox();
              }
          }

        );
      },
    );
  }


}

