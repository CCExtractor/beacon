import 'package:beacon/config/enviornment_config.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_cubit.dart';
import 'package:beacon/presentation/auth/verification_cubit/verification_cubit.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_cubit.dart';
import 'package:beacon/presentation/hike/cubit/hike_cubit/hike_cubit.dart';
import 'package:beacon/presentation/hike/cubit/location_cubit/location_cubit.dart';
import 'package:beacon/presentation/hike/cubit/panel_cubit/panel_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/presentation/group/cubit/members_cubit/members_cubit.dart';
import 'package:beacon/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvironmentConfig.loadEnvVariables();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // loading variables

  await setupLocator();
  await localApi.init();
  await localNotif.initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: ResponsiveSizer(
        builder: (context, orientation, deviceType) => MultiBlocProvider(
          providers: providers,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Beacon',
            theme: ThemeData(
                fontFamily: 'Inter',
                scaffoldBackgroundColor: Color(0xffFAFAFA)),
            routerConfig: appRouter.config(),
          ),
        ),
      ),
    );
  }

  final List<BlocProvider<dynamic>> providers = [
    BlocProvider<AuthCubit>(
      create: (context) => locator(),
    ),
    BlocProvider<VerificationCubit>(
      create: (context) => locator(),
    ),
    BlocProvider<HomeCubit>(
      create: (context) => locator(),
    ),
    BlocProvider<GroupCubit>(
      create: (context) => locator(),
    ),
    BlocProvider<MembersCubit>(
      create: (context) => locator(),
    ),
    BlocProvider<HikeCubit>(
      create: (context) => locator(),
    ),
    BlocProvider<LocationCubit>(
      create: (context) => locator(),
    ),
    BlocProvider<PanelCubit>(
      create: (context) => locator(),
    )
  ];
}
