import 'dart:math' as math;

import 'package:beacon/config/enviornment_config.dart';
import 'package:beacon/core/utils/constants.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // loading variables
  await EnvironmentConfig.loadEnvVariables();

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
            theme: ThemeData(fontFamily: 'FuturaBold'),
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

class DrawCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kBlue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, 0), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// class DrawCircle extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = kBlue
//       ..style = PaintingStyle.fill;

//     final path = Path();

//     // Convert angles to radians
//     final angle1Rad = 60 * (math.pi / 180);
//     final angle2Rad = 30 * (math.pi / 180);

//     // Calculate the height of the cut based on the rectangle width and angle
//     final cutHeight1 = size.width * math.tan(angle1Rad);
//     final cutHeight2 = size.width * math.tan(angle2Rad);

//     // Define the path
//     path.moveTo(0, cutHeight1); // Start at the top-left corner with a cut
//     path.lineTo(size.width, 0); // Top-right corner
//     path.lineTo(
//         size.width, size.height - cutHeight2); // Bottom-right corner with a cut
//     path.lineTo(0, size.height); // Bottom-left corner
//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
