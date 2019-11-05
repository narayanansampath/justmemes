import 'package:flutter/material.dart';
import 'package:just_memes/screens/HomeScreen/home_screen.dart';
import 'package:just_memes/screens/OnboardingScreen/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {
  BuildContext _ctx;
  bool firstLaunch;

  @override
  void initState() {
    super.initState();
    checkFirstLaunch();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Container();
  }

  afterSplash(bool firstLaunch) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (firstLaunch) {
        print('firstLaunch: true');
        Navigator.pushReplacement(
            _ctx,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    OnBoardingScreen()));
        prefs.setBool('firstLaunch', false);
      } else {
        print('firstLaunch: false');
        Navigator.pushReplacement(
            _ctx,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    HomeScreen()));
      }
  }

  void checkFirstLaunch() async {
    firstLaunch = await setFirstLaunch();
    afterSplash(firstLaunch);
  }

   Future setFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstLaunch = prefs.getBool('firstLaunch');
    if (firstLaunch != null) {
      return false;
    } else{
      prefs.setBool('firstLaunch', true);
      print('firstLaunch: true');
      return true;
    }
  }
}
