import 'package:flutter/material.dart';
import 'package:ynotes/ui/animations/fade_animation.dart';

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
              child: Text("Go to safe area", style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pushReplacementNamed(context, "/summary"),
            )
          ],
        )),
      ),
    );
  }
}
