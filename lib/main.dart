import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ynotes/UI/carousel.dart';
import 'package:ynotes/UI/loginPage.dart';
import 'package:ynotes/UI/tabBuilder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ynotes/land.dart';

void main() {


  runApp(
    MaterialApp(
      home: Logger(),
    ),
  );

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