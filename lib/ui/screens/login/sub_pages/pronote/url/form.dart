import 'package:flutter/material.dart';
import 'package:ynotes/ui/screens/login/w/widgets.dart';

class LoginPronoteUrlFormPageArguments {
  final String url;

  const LoginPronoteUrlFormPageArguments(this.url);
}

class LoginPronoteUrlFormPage extends StatelessWidget {
  const LoginPronoteUrlFormPage({Key? key}) : super(key: key);

  final String _subtitle = "Pronote";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as LoginPronoteUrlFormPageArguments;

    return LoginForm(subtitle: _subtitle, url: args.url);
  }
}
