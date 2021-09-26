import 'package:flutter/material.dart';
import 'package:ynotes/ui/screens/login/w/widgets.dart';

class LoginEcoleDirectePage extends StatelessWidget {
  const LoginEcoleDirectePage({Key? key}) : super(key: key);

  final String _subtitle = "EcoleDirecte";

  @override
  Widget build(BuildContext context) {
    return LoginForm(subtitle: _subtitle);
  }
}
