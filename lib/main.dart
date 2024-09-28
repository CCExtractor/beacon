// main.dart
import 'package:beacon/Bloc/config/enviornment_config.dart';
import 'package:beacon/Bloc/presentation/cubit/auth_cubit.dart';
import 'package:beacon/Bloc/presentation/cubit/group_cubit.dart';
import 'package:beacon/Bloc/presentation/cubit/home_cubit.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/old/components/view_model/base_view_model.dart';
import 'package:beacon/old/components/views/base_view.dart';
import 'package:beacon/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvironmentConfig.loadEnvVariables();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  setupLocator();
  // starting local api for storing data
  await localApi.init();

  await localNotif!.initialize();
  await hiveDb!.init();

  AppRouter _appRouter = AppRouter();

  runApp(MyApp(router: _appRouter));
}

class MyApp extends StatefulWidget {
  final AppRouter router;

  const MyApp({Key? key, required this.router}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = widget.router;
  }

  void restartApp() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: Sizer(
        builder: (context, orientation, deviceType) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(authUseCase: locator()),
            ),
            BlocProvider(
              create: (context) => HomeCubit(homeUseCase: locator()),
            ),
            BlocProvider(
              create: (context) => GroupCubit(locator()),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Beacon',
            theme: ThemeData(fontFamily: 'FuturaBold'),
            routerConfig: _appRouter.config(),
          ),
        ),
      ),
    );
  }
}

class DemoPageView extends StatelessWidget {
  const DemoPageView({required Key key}) : super(key: key);

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
