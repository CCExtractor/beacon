import 'package:beacon/config/environment_config.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/router.dart' as router;
import 'package:beacon/view_model/base_view_model.dart';
import 'package:beacon/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvironmentConfig.loadEnvVariables();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  setupLocator();
  localNotif.initialize();
  await hiveDb.init();
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
