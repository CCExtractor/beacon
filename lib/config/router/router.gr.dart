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
    AdvancedOptionsScreenRoute.name: (routeData) {
      final args = routeData.argsAs<AdvancedOptionsScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AdvancedOptionsScreen(
          key: args.key,
          durationController: args.durationController,
          title: args.title,
          isScheduled: args.isScheduled,
          startDate: args.startDate,
          startTime: args.startTime,
          groupId: args.groupId,
        ),
      );
    },
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
        child: GroupScreen(
          args.group,
          key: args.key,
        ),
      );
    },
    HikeScreenRoute.name: (routeData) {
      final args = routeData.argsAs<HikeScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HikeScreen(
          key: args.key,
          beacon: args.beacon,
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
    ProfileScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileScreen(),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    VerificationScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const VerificationScreen(),
      );
    },
  };
}

/// generated route for
/// [AdvancedOptionsScreen]
class AdvancedOptionsScreenRoute
    extends PageRouteInfo<AdvancedOptionsScreenRouteArgs> {
  AdvancedOptionsScreenRoute({
    Key? key,
    required TextEditingController durationController,
    required String title,
    required bool isScheduled,
    DateTime? startDate,
    TimeOfDay? startTime,
    required String groupId,
    List<PageRouteInfo>? children,
  }) : super(
          AdvancedOptionsScreenRoute.name,
          args: AdvancedOptionsScreenRouteArgs(
            key: key,
            durationController: durationController,
            title: title,
            isScheduled: isScheduled,
            startDate: startDate,
            startTime: startTime,
            groupId: groupId,
          ),
          initialChildren: children,
        );

  static const String name = 'AdvancedOptionsScreenRoute';

  static const PageInfo<AdvancedOptionsScreenRouteArgs> page =
      PageInfo<AdvancedOptionsScreenRouteArgs>(name);
}

class AdvancedOptionsScreenRouteArgs {
  const AdvancedOptionsScreenRouteArgs({
    this.key,
    required this.durationController,
    required this.title,
    required this.isScheduled,
    this.startDate,
    this.startTime,
    required this.groupId,
  });

  final Key? key;

  final TextEditingController durationController;

  final String title;

  final bool isScheduled;

  final DateTime? startDate;

  final TimeOfDay? startTime;

  final String groupId;

  @override
  String toString() {
    return 'AdvancedOptionsScreenRouteArgs{key: $key, durationController: $durationController, title: $title, isScheduled: $isScheduled, startDate: $startDate, startTime: $startTime, groupId: $groupId}';
  }
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
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          GroupScreenRoute.name,
          args: GroupScreenRouteArgs(
            group: group,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'GroupScreenRoute';

  static const PageInfo<GroupScreenRouteArgs> page =
      PageInfo<GroupScreenRouteArgs>(name);
}

class GroupScreenRouteArgs {
  const GroupScreenRouteArgs({
    required this.group,
    this.key,
  });

  final GroupEntity group;

  final Key? key;

  @override
  String toString() {
    return 'GroupScreenRouteArgs{group: $group, key: $key}';
  }
}

/// generated route for
/// [HikeScreen]
class HikeScreenRoute extends PageRouteInfo<HikeScreenRouteArgs> {
  HikeScreenRoute({
    Key? key,
    required BeaconEntity beacon,
    required bool? isLeader,
    List<PageRouteInfo>? children,
  }) : super(
          HikeScreenRoute.name,
          args: HikeScreenRouteArgs(
            key: key,
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
    this.key,
    required this.beacon,
    required this.isLeader,
  });

  final Key? key;

  final BeaconEntity beacon;

  final bool? isLeader;

  @override
  String toString() {
    return 'HikeScreenRouteArgs{key: $key, beacon: $beacon, isLeader: $isLeader}';
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
/// [ProfileScreen]
class ProfileScreenRoute extends PageRouteInfo<void> {
  const ProfileScreenRoute({List<PageRouteInfo>? children})
      : super(
          ProfileScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileScreenRoute';

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

/// generated route for
/// [VerificationScreen]
class VerificationScreenRoute extends PageRouteInfo<void> {
  const VerificationScreenRoute({List<PageRouteInfo>? children})
      : super(
          VerificationScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'VerificationScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
