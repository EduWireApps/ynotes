import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ynotes/UI/carousel.dart';
import 'package:ynotes/UI/loginPage.dart';
import 'package:ynotes/UI/tabBuilder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ynotes/landGrades.dart';
import 'package:sentry/sentry.dart';
final SentryClient _sentry = SentryClient(dsn: "https://c55eb82b0cab4437aeda267bb0392959@sentry.io/3147528");
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

}

Future<Null> main() async {
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {

    _sentry.captureException(
      exception: details.exception,
      stackTrace: details.stack,
    );


  };

  runZoned<Future<Null>>(() async {
    runApp( new MaterialApp(
      home: Logger(),
    ),);
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

class Logger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(

//Main container
        body: LoginPage() );
  }
}


class carousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: SafeArea(child: SlidingCarousel(),));
  }
}

class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        body: SafeArea(child: TabBuilder(),));
  }
}