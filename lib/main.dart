import 'dart:io';

import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:catcher/catcher_plugin.dart';
import 'package:just_memes/constants/admob_id.dart';
import 'package:just_memes/screens/SplashScreen/splash_screen.dart';
import 'constants/dsn.dart';

void main() {
  Admob.initialize(AppId);
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [
    SentryHandler(dsn)
  ]);
  //CatcherOptions(DialogReportMode(), [ConsoleHandler()]);

  //release configuration
  CatcherOptions releaseOptions = CatcherOptions(SilentReportMode(), [
    SentryHandler(dsn)
  ]);

  //profile configuration
  CatcherOptions profileOptions = CatcherOptions(
    SilentReportMode(),
    [ConsoleHandler(), ToastHandler(), SentryHandler(dsn)],
    handlerTimeout: 10000,
    customParameters: {"JustMemes": "crash log"},
  );

  //MyApp is root widget
  Catcher(MyApp(),
      debugConfig: debugOptions,
      releaseConfig: releaseOptions,
      profileConfig: profileOptions);
      Catcher(MyApp());
}

Widget getErrorWidget(BuildContext context, FlutterErrorDetails error) {
  return Container(color: Colors.white, child:
  Center(
    child: Text(
      "Error occured, please restart the application. If the problem persists contact the developer.",
      style: Theme.of(context).textTheme.title.copyWith(color: Colors.black),
      textAlign: TextAlign.center,
    ),
  ),);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return getErrorWidget(context, errorDetails);
    };
    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      //override default error screen
      builder: (BuildContext context, Widget widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return getErrorWidget(context, errorDetails);
        };

        return widget;
      },
      debugShowCheckedModeBanner: false,
      title: 'Just Memes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenWidget(), //HomeScreen(),
    );
  }
}
