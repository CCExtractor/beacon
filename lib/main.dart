import 'package:beacon/locator.dart';
import 'package:beacon/views/auth_screen.dart';
import 'package:beacon/views/create_join_beacon.dart';
import 'package:beacon/views/home.dart';
import 'package:beacon/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'models/user/user_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(UserAdapter());
  await Hive.openBox<User>('currentUser');
  setupLocator();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Beacon',
    navigatorKey: NavigationService().navigatorKey,
    theme: ThemeData(fontFamily: 'FuturaBold'),
    initialRoute: '/auth',
    routes: <String, WidgetBuilder>{
      '/init': (BuildContext context) => WelcomeScreen(),
      '/auth': (BuildContext context) => AuthScreen(),
      '/main': (BuildContext context) => MainScreen()
    },
  ));
}
