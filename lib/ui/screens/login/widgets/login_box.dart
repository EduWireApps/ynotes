import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/ui/screens/login/content/loginTextContent.dart';
import 'package:ynotes/ui/screens/login/widgets/login_text_field.dart';
import 'package:ynotes_components/ynotes_components.dart';

class LoginBox extends StatefulWidget {
  final TextEditingController passwordCon;
  final TextEditingController loginCon;
  final VoidCallback callback;

  const LoginBox(
      {Key? key,
      required this.passwordCon,
      required this.loginCon,
      required this.callback})
      : super(key: key);

  @override
  _LoginBoxState createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 1.1.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), color: currentTheme.colors.neutral.shade300),
      child: Column(
        children: [
          LoginTextField(label: LoginPageTextContent.login.login, controller: widget.loginCon),
          SizedBox(
            height: 5,
          ),
          LoginTextField(
            label: LoginPageTextContent.login.password,
            controller: widget.passwordCon,
            password: true,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Text(
                  LoginPageTextContent.login.forgotPassword,
                  style: TextStyle(
                      fontFamily: "Asap", color: currentTheme.colors.neutral.shade500, decoration: TextDecoration.underline),
                ),
              ),
              Spacer(),
              YButton(onPressed: () => widget.callback(), text: "Se connecter")
            ],
          )
        ],
      ),
    );
  }
}
