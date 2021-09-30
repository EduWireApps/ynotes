import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/routing_utils.dart';
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
    final args = RoutingUtils.getArgs<LoginPronoteUrlFormPageArguments>(context);

    return LoginForm(subtitle: _subtitle, url: args.url);
  }
}
