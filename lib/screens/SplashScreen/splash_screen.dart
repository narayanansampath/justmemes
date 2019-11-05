
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'after_splash.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreenWidget> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SplashScreen(
          seconds: 3,
          navigateAfterSeconds: AfterSplash(),
          backgroundColor: Colors.white,
          loaderColor: Colors.white,
        ),
        Center(
          child: Container(
            height: 200,
            width: 200,
            child: ClipRRect(
              child: Image.asset(
                'assets/icon4x.png',
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
      ],
    );
  }


}
