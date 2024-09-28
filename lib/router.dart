import 'package:auto_route/auto_route.dart';
import 'package:beacon/Bloc/domain/entities/group/group_entity.dart';
import 'package:beacon/Bloc/presentation/screens/splash_screen.dart';
import 'package:beacon/old/components/models/beacon/beacon.dart';
import 'package:beacon/Bloc/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:beacon/old/components/utilities/constants.dart';
import 'package:beacon/Bloc/presentation/screens/auth_screen.dart';
import 'package:beacon/Bloc/presentation/screens/group_screen.dart';
import 'package:beacon/Bloc/presentation/screens/hike_screen.dart';
part 'router.gr.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.authScreen:
      return MaterialPageRoute(
          builder: (context) => const AuthScreen(key: Key('auth')));
    case Routes.mainScreen:
      return MaterialPageRoute(
          builder: (context) => HomeScreen(key: Key('MainScreen')));
    case Routes.hikeScreen:
      HikeScreen? arguments = settings.arguments as HikeScreen?;
      return MaterialPageRoute(
          builder: (context) => HikeScreen(
                arguments!.beacon,
                isLeader: arguments.isLeader,
              ));
    case Routes.groupScreen:
      GroupScreen? arguments = settings.arguments as GroupScreen?;
      return MaterialPageRoute(
          builder: (context) => GroupScreen(
                arguments!.group,
              ));
    default:
      return MaterialPageRoute(
          builder: (context) => const SplashScreen(key: Key('SplashScreen')));
  }
}

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashScreenRoute.page, initial: true, path: '/'),
        AutoRoute(page: AuthScreenRoute.page, path: '/auth'),
        AutoRoute(page: HomeScreenRoute.page, path: '/home'),
        AutoRoute(
          page: HikeScreenRoute.page,
          path: '/hike',
        ),
        AutoRoute(page: GroupScreenRoute.page, path: '/group'),
      ];
}
