import 'package:flutter/material.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';

class LoginLvsPage extends StatelessWidget {
  const LoginLvsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginForm(subtitle: LoginContent.lvs.subtitle);
  }
}
