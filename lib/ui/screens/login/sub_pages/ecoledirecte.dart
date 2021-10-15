import 'package:flutter/material.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';

class LoginEcoleDirectePage extends StatelessWidget {
  const LoginEcoleDirectePage({Key? key}) : super(key: key);

  final String _subtitle = "EcoleDirecte";

  @override
  Widget build(BuildContext context) {
    return LoginForm(subtitle: LoginContent.ecoleDirecte.subtitle);
  }
}
