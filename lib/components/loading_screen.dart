import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utilities/constants.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/hikers_group.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(flex: 3, child: SizedBox()),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SpinKitThreeBounce(
                        color: kYellow,
                        size: 40,
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
