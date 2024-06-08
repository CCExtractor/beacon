import 'package:auto_route/auto_route.dart';
import 'package:beacon/Bloc/domain/usecase/auth_usecase.dart';
import 'package:flutter/material.dart';
import 'package:beacon/locator.dart';
import '../../../old/components/loading_screen.dart';

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
    _handleNavigation();
    super.initState();
  }

  _handleNavigation() async {
    await localApi.init();
    bool? isLoggedIn = await localApi.userloggedIn();
    final authUseCase = locator<AuthUseCase>();

    if (isLoggedIn == true) {
      bool isConnected = await utils.checkInternetConnectivity();
      if (isConnected) {
        final userInfo = await authUseCase.getUserInfoUseCase();
        if (userInfo.data != null) {
          AutoRouter.of(context).replaceNamed('/home');
        } else {
          AutoRouter.of(context).replaceNamed('/auth');
        }
      } else {
        AutoRouter.of(context).replaceNamed('/home');
      }
    } else {
      AutoRouter.of(context).replaceNamed('/auth');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('SplashScreenScaffold'),
      body: LoadingScreen(),
    );
  }
}
