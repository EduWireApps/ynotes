import 'package:flutter/material.dart';
import 'package:ynotes_packages/components.dart';

class IntroConfigPage extends StatefulWidget {
  const IntroConfigPage({Key? key}) : super(key: key);

  @override
  _IntroConfigPageState createState() => _IntroConfigPageState();
}

class _IntroConfigPageState extends State<IntroConfigPage> {
  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "Config"),
        body: YButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            text: "Go to login page"));
  }
}
