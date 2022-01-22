import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/landmarks/landmark.dart';
import 'package:beacon/models/location/location.dart';
import 'package:beacon/router.dart' as router;
import 'package:beacon/view_model/base_view_model.dart';
import 'package:beacon/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hive/hive.dart';
import 'package:sizer/sizer.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'models/user/user_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(UserAdapter())
    ..registerAdapter(BeaconAdapter())
    ..registerAdapter(LocationAdapter())
    ..registerAdapter(LandmarkAdapter());
  await Hive.openBox<User>('currentUser');
  await Hive.openBox<Beacon>('beacons');
  setupLocator();
  localNotif.initialize();
  runApp(
    OverlaySupport(
      child: Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Beacon',
          navigatorKey: navigationService.navigatorKey,
          theme: ThemeData(fontFamily: 'FuturaBold'),
          initialRoute: '/',
          onGenerateRoute: router.generateRoute,
        ),
      ),
    ),
  );
}

class DemoPageView extends StatelessWidget {
  const DemoPageView({@required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<DemoViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Demo Page'),
        ),
        body: Container(
          child: Text(model.title),
        ),
      ),
    );
  }
}

class DemoViewModel extends BaseModel {
  final String _title = "Title from the viewMode GSoC branch";
  String get title => _title;
}
