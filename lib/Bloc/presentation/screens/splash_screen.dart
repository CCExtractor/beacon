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
  // Uri? _initialUri;
  // Uri? _latestUri;
  // late StreamSubscription _sub;
  bool isCheckingUrl = false;

  // Future<void> _handleInitialUri() async {
  //   // _sub = uriLinkStream.listen((Uri? uri) {
  //   //   if (!mounted) return;
  //   //   setState(() {
  //   //     _latestUri = uri;
  //   //   });
  //   // }, onError: (Object err) {
  //   //   if (!mounted) return;
  //   //   setState(() {
  //   //     _latestUri = null;
  //   //   });
  //   // });
  //   // try {
  //   //   final uri = await getInitialUri();
  //   //   if (!mounted) return;
  //   //   setState(() => _initialUri = uri);
  //   // } on PlatformException {
  //   //   if (!mounted) return;
  //   //   setState(() => _initialUri = null);
  //   // } on FormatException catch (err) {
  //   //   debugPrint(err.toString());
  //   //   if (!mounted) return;
  //   //   setState(() => _initialUri = null);
  //   // }

  //   // checking if user is login or not ?

  //   // await userConfig!.userLoggedIn().then((value) async {
  //   //   if (_latestUri == null && _initialUri == null) {
  //   //     if (value || localApi.userBox.containsKey('currentUser')) {
  //   //       AutoRouter.of(context).replaceNamed('/home');
  //   //     } else {
  //   //       AutoRouter.of(context).replaceNamed('/auth');
  //   //     }
  //   //   } else {
  //   //     if (_initialUri != null) {
  //   //       var shortcode = _initialUri!.queryParameters['shortcode'];
  //   //       if (value) {
  //   //         await databaseFunctions!.joinBeacon(shortcode).then((val) {
  //   //           if (val != null) {
  //   //             // navigationService!.pushScreen('/hikeScreen',
  //   //             //     arguments: HikeScreen(val, isLeader: false));

  //   //             AutoRouter.of(context).pushNamed('/hike');
  //   //           } else {
  //   //             // navigationService!.pushReplacementScreen('/main');
  //   //             AutoRouter.of(context).replaceNamed('/hike');
  //   //           }
  //   //         });
  //   //       } else {
  //   //         // login in anonymously and join hike
  //   //         await databaseFunctions!.signup(name: "Anonymous");
  //   //         await databaseFunctions!.joinBeacon(shortcode).then((val) async {
  //   //           // navigationService!.pushScreen('/hikeScreen',
  //   //           //     arguments: HikeScreen(val, isLeader: false));
  //   //           AutoRouter.of(context).pushNamed('/hike');
  //   //         });
  //   //       }
  //   //     }
  //   //   }
  //   // });
  // }

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
        AutoRouter.of(context).replaceNamed('/auth');
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
