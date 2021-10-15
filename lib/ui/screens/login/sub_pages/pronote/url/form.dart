import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/routing_utils.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';

class LoginPronoteUrlFormPageArguments {
  final String url;

  const LoginPronoteUrlFormPageArguments(this.url);
}

class LoginPronoteUrlFormPage extends StatelessWidget {
  const LoginPronoteUrlFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = RoutingUtils.getArgs<LoginPronoteUrlFormPageArguments>(context);

    return LoginForm(subtitle: LoginContent.pronote.url.form.subtitle, url: args.url);
  }
}
