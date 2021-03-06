import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pothole_detection_app/landing_page.dart';
import 'package:provider/provider.dart';

import 'app/services/auth.dart';
import 'sign_in_page.dart';

//jashan line
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Pothole App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LandingPage(),
      ),
    );
  }
}

