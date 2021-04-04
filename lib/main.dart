import 'package:beacon/initiation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Beacon',
    theme: ThemeData(brightness: Brightness.dark),
    debugShowCheckedModeBanner: false,
    initialRoute: '/init',
    // define the routes
    routes: <String, WidgetBuilder>{
      '/init': (BuildContext context) => Initiation(),
      // '/root': (BuildContext context) => RootPage(),
      // '/login': (BuildContext context) => LoginPage(),
      // '/home': (BuildContext context) => HomePage(currentIndex: 1),
      // '/event': (BuildContext context) => HomePage(currentIndex: 0),
      // '/profilesetup': (BuildContext context) => ProfileSetup(),
    },
  ));
}
