import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ynotes/UI/loginPage.dart';
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
        body: Login() );
  }
}
