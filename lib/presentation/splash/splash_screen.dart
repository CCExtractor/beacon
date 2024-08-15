import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:beacon/config/router/router.dart';
import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/usecase/auth_usecase.dart';
import 'package:beacon/domain/usecase/group_usecase.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/auth/verification_cubit/verification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

import '../widgets/loading_screen.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isCheckingUrl = false;

  @override
  void initState() {
    handleLinks();
    super.initState();
  }

  StreamSubscription? _sub;
  Uri? _latestUri;
  Uri? _initialUri;

  handleLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
      });
    }, onError: (Object err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
      });
    });

    try {
      final uri = await getInitialUri();
      if (!mounted) return;
      setState(() => _initialUri = uri);
    } on PlatformException {
      if (!mounted) return;
      setState(() => _initialUri = null);
    } on FormatException catch (err) {
      debugPrint(err.toString());
      if (!mounted) return;
      setState(() => _initialUri = null);
    }

    await sp.init();
    await localApi.init();
    final authUseCase = locator<AuthUseCase>();

    await localApi.userloggedIn().then((value) async {
      if (_latestUri == null && _initialUri == null) {
        bool isConnected = await utils.checkInternetConnectivity();
        if (isConnected) {
          final userInfo = await authUseCase.getUserInfoUseCase();
          if (userInfo.data != null) {
            await func(userInfo.data!);
          } else {
            appRouter.replaceNamed('/auth');
          }
        } else {
          appRouter.replaceNamed('/home');
          utils.showSnackBar(
              'Please connect to your internet connection!', context);
        }
      } else {
        if (_initialUri != null) {
          var shortcode = _initialUri!.queryParameters['shortcode'];
          if (value == true && shortcode != null) {
            await locator<GroupUseCase>().joinHike(shortcode).then((dataState) {
              if (dataState is DataSuccess) {
                appRouter.push(HikeScreenRoute(
                    beacon: dataState.data!,
                    isLeader: dataState.data!.id == localApi.userModel.id));
              } else {
                appRouter.push(HomeScreenRoute());
              }
            });
          }
        }
      }
    });
  }

  Future<void> func(UserEntity user) async {
    var time = await sp.loadData('time');
    var otp = await sp.loadData('otp');
    if (user.isVerified == true) {
      await sp.deleteData('time');
      await sp.deleteData('otp');
      appRouter.pushNamed('/home');
    } else {
      if (time != null && otp != null) {
        if (DateTime.now().difference(DateTime.parse(time)).inMinutes < 2) {
          locator<VerificationCubit>().emitVerificationSentstate(otp);
          appRouter.push(VerificationScreenRoute());
          utils.showSnackBar('Please verify your email', context);
        } else {
          await sp.deleteData('time');
          await sp.deleteData('otp');
          appRouter.pushNamed('/auth');
        }
      } else {
        await sp.deleteData('time');
        await sp.deleteData('otp');
        appRouter.replaceNamed('/auth');
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingScreen(),
    );
  }
}
