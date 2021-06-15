import 'package:beacon/screens/auth_screen.dart';
import 'package:beacon/screens/create_join_beacon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  runApp(

      MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Beacon',
    theme: ThemeData(fontFamily: 'FuturaBold'),
    initialRoute: '/auth',
    routes: <String, WidgetBuilder>{
      '/init': (BuildContext context) => WelcomeScreen(),
      '/auth': (BuildContext context) => AuthScreen(),
    },
  ));
}
