import 'package:flutter/material.dart';
import 'package:ynotes/ui/screens/login/w/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return LoginPageStructure(
      backRouteName: "/",
    );
  }
}
