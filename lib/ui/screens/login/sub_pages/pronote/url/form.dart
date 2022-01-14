import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';

class LoginPronoteUrlFormPage extends StatelessWidget {
  const LoginPronoteUrlFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = AppRouter.getArgs<String>(context);

    return LoginForm(subtitle: LoginContent.pronote.url.form.subtitle, url: url);
  }
}
