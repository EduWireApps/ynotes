import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/EcoleDirecte.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/ui/animations/FadeAnimation.dart';
import 'package:ynotes/usefulMethods.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: FadeAnimation(
        0.2,
        Center(
            child: Column(
          children: [
            Icon(
              Icons.error,
              color: Colors.white,
            ),
            TextButton(
              child: Text("Go to safe area"),
              onPressed: () => Navigator.pushNamed(context, "/test"),
            )
          ],
        )),
      ),
    );
  }
}
