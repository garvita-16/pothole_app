
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/app/admin/admin.dart';
import 'package:pothole_detection_app/app/home_page.dart';
import 'package:pothole_detection_app/app/models/user.dart';
import 'package:pothole_detection_app/app/services/database.dart';
import 'package:provider/provider.dart';

class LoaderPage extends StatefulWidget {
  //const LoaderPage({Key? key}) : super(key: key);

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  bool isLoading = true;
  bool isAdmin = false;
  Future<void> _pageDecider(BuildContext context) async{
    Database database = Provider.of<Database>(context, listen: false);
    UserData user = await database.getUser();
    if(user!= null && user.isAdmin!= null){
      isAdmin = user.isAdmin;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _pageDecider(context);
    if(isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else{
      Database database = Provider.of<Database>(context, listen: false);
      return isAdmin ? AdminPage() : HomePage(database: database);
    }
  }
}
