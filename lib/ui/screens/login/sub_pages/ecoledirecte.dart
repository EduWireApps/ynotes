import 'package:flutter/material.dart';
import 'package:ynotes/ui/screens/login/w/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginEcoleDirectePage extends StatelessWidget {
  const LoginEcoleDirectePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginPageStructure(
        subtitle: "EcoleDirecte",
        body: Padding(
          padding: YPadding.px(YScale.s2),
          child: Column(
            children: [
              Text("form"),
              YFormField(
                type: TextInputType.text,
                onChanged: (String value) {
                  print(value);
                },
              ),
              YButton(
                  text: "Se connecter",
                  onPressed: () {
                    print("enabled");
                  },
                  block: true,
                  isDisabled: true,
                  onPressedDisabled: () {
                    print("disabled");
                  })
            ],
          ),
        ));
  }
}
