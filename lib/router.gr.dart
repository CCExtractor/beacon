// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AuthScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthScreen(),
      );
    },
    GroupScreenRoute.name: (routeData) {
      final args = routeData.argsAs<GroupScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GroupScreen(args.group),
      );
    },
    HikeScreenRoute.name: (routeData) {
      final args = routeData.argsAs<HikeScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HikeScreen(
          args.beacon,
          isLeader: args.isLeader,
        ),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [AuthScreen]
class AuthScreenRoute extends PageRouteInfo<void> {
  const AuthScreenRoute({List<PageRouteInfo>? children})
      : super(
          AuthScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GroupScreen]
class GroupScreenRoute extends PageRouteInfo<GroupScreenRouteArgs> {
  GroupScreenRoute({
    required GroupEntity group,
    List<PageRouteInfo>? children,
  }) : super(
          GroupScreenRoute.name,
          args: GroupScreenRouteArgs(group: group),
          initialChildren: children,
        );

  static const String name = 'GroupScreenRoute';

  static const PageInfo<GroupScreenRouteArgs> page =
      PageInfo<GroupScreenRouteArgs>(name);
}

class GroupScreenRouteArgs {
  const GroupScreenRouteArgs({required this.group});

  final GroupEntity group;

  @override
  String toString() {
    return 'GroupScreenRouteArgs{group: $group}';
  }
}

/// generated route for
/// [HikeScreen]
class HikeScreenRoute extends PageRouteInfo<HikeScreenRouteArgs> {
  HikeScreenRoute({
    required Beacon? beacon,
    bool? isLeader,
    List<PageRouteInfo>? children,
  }) : super(
          HikeScreenRoute.name,
          args: HikeScreenRouteArgs(
            beacon: beacon,
            isLeader: isLeader,
          ),
          initialChildren: children,
        );

  static const String name = 'HikeScreenRoute';

  static const PageInfo<HikeScreenRouteArgs> page =
      PageInfo<HikeScreenRouteArgs>(name);
}

class HikeScreenRouteArgs {
  const HikeScreenRouteArgs({
    required this.beacon,
    this.isLeader,
  });

  final Beacon? beacon;

  final bool? isLeader;

  @override
  String toString() {
    return 'HikeScreenRouteArgs{beacon: $beacon, isLeader: $isLeader}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeScreenRoute extends PageRouteInfo<void> {
  const HomeScreenRoute({List<PageRouteInfo>? children})
      : super(
          HomeScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreen]
class SplashScreenRoute extends PageRouteInfo<void> {
  const SplashScreenRoute({List<PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
