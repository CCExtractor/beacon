import 'package:auto_route/auto_route.dart';
import 'package:beacon/config/router/router.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/usecase/auth_usecase.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/auth/verification_cubit/verification_cubit.dart';
import 'package:flutter/material.dart';

import '../widgets/loading_screen.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await sp.init();
    await localApi.init();
    final authUseCase = locator<AuthUseCase>();

    await localApi.userloggedIn().then((loggedIn) async {
      if (!loggedIn!) {
        appRouter.replaceNamed('/auth');
        return;
      }

      bool isConnected = await utils.checkInternetConnectivity();
      if (isConnected) {
        final userInfo = await authUseCase.getUserInfoUseCase();
        if (userInfo.data != null) {
          await _handleUser(userInfo.data!);
        } else {
          appRouter.replaceNamed('/auth');
        }
      } else {
        appRouter.replaceNamed('/home');
        utils.showSnackBar(
            'Please connect to your internet connection!', context);
      }
    });
  }

  Future<void> _handleUser(UserEntity user) async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingScreen(),
    );
  }
}
