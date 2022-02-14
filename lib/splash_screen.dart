import 'dart:async';

import 'package:beacon/views/hike_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beacon/locator.dart';
import 'package:uni_links/uni_links.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({@required Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Uri _initialUri;
  Uri _latestUri;
  StreamSubscription _sub;
  bool isCheckingUrl = false;

  Future<void> _handleInitialUri() async {
    _sub = uriLinkStream.listen((Uri uri) {
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
    await databaseFunctions.init();
    await userConfig.userLoggedIn().then((value) async {
      if (_latestUri == null && _initialUri == null) {
        if (value || hiveDb.currentUserBox.containsKey('user')) {
          navigationService.pushReplacementScreen('/main');
        } else {
          navigationService.pushReplacementScreen('/auth');
        }
      } else {
        if (_initialUri != null) {
          var shortcode = _initialUri.queryParameters['shortcode'];
          if (value) {
            await databaseFunctions.joinBeacon(shortcode).then((val) {
              if (val != null) {
                navigationService.pushScreen('/hikeScreen',
                    arguments: HikeScreen(val, isLeader: false));
              } else {
                navigationService.pushReplacementScreen('/main');
              }
            });
          } else {
            // login in anonymously and join hike
            await databaseFunctions.signup(name: "Anonymous");
            await databaseFunctions.joinBeacon(shortcode).then((val) async {
              if (value != null) {
                navigationService.pushScreen('/hikeScreen',
                    arguments: HikeScreen(val, isLeader: false));
              } else {
                navigationService.pushReplacementScreen('/main');
              }
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    _handleInitialUri();
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('SplashScreenScaffold'),
      body: Center(
        child: new Image(image: new AssetImage('images/hikers_group.png')),
      ),
    );
  }
}
