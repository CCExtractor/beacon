import 'package:beacon/screens/create_join_beacon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Beacon',
    theme: ThemeData(fontFamily: 'FuturaBold'),
    initialRoute: '/init',
    routes: <String, WidgetBuilder>{
      '/init': (BuildContext context) => WelcomeScreen(),
    },
  ));
}
