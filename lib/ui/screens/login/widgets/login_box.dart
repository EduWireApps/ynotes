import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ynotes/ui/screens/login/content/login_text_content.dart';
import 'package:ynotes/ui/screens/login/widgets/login_text_field.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/components.dart';

class LoginBox extends StatefulWidget {
  final TextEditingController passwordCon;
  final TextEditingController loginCon;
  final VoidCallback callback;
  final VoidCallback longPressCallback;

  const LoginBox(
      {Key? key,
      required this.passwordCon,
      required this.loginCon,
      required this.callback,
      required this.longPressCallback})
      : super(key: key);

  @override
  _LoginBoxState createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 1.1.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), color: theme.colors.foregroundLightColor),
      child: Column(
        children: [
          LoginTextField(label: LoginPageTextContent.login.login, controller: widget.loginCon),
          const SizedBox(
            height: 5,
          ),
          LoginTextField(
            label: LoginPageTextContent.login.password,
            controller: widget.passwordCon,
            password: true,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Text(
                  LoginPageTextContent.login.forgotPassword,
                  style: TextStyle(
                      fontFamily: "Asap", color: theme.colors.foregroundColor, decoration: TextDecoration.underline),
                ),
              ),
              const Spacer(),
              YButton(
                  onPressed: () => widget.callback(),
                  onLongPress: () => widget.longPressCallback(),
                  text: "Se connecter")
            ],
          )
        ],
      ),
    );
  }
}
