import 'package:auto_route/auto_route.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/presentation/auth/verfication_screen.dart';
import 'package:beacon/presentation/splash/splash_screen.dart';
import 'package:beacon/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:beacon/presentation/auth/auth_screen.dart';
import 'package:beacon/presentation/group/group_screen.dart';
import 'package:beacon/presentation/hike/hike_screen.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashScreenRoute.page, initial: true, path: '/'),
        AutoRoute(page: AuthScreenRoute.page, path: '/auth'),
        AutoRoute(page: HomeScreenRoute.page, path: '/home'),
        AutoRoute(
          page: HikeScreenRoute.page,
          path: '/hike/:hikeDetails',
        ),
        AutoRoute(page: GroupScreenRoute.page),
        AutoRoute(
          page: VerificationScreenRoute.page,
        ),
      ];
}
