import 'package:flutter/material.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/login/w/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/utilities.dart';

class _Credentials {
  String? username;
  String? password;

  _Credentials({this.username, this.password});
}

class LoginEcoleDirectePage extends StatefulWidget {
  const LoginEcoleDirectePage({Key? key}) : super(key: key);

  @override
  _LoginEcoleDirectePageState createState() => _LoginEcoleDirectePageState();
}

class _LoginEcoleDirectePageState extends State<LoginEcoleDirectePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final _Credentials _credentials = _Credentials();
  bool _canNavigate = true;

  Future<void> submit(bool b) async {
    print("valid: $b");
    setState(() {
      _loading = true;
    });
    if (b) {
      _formKey.currentState!.save();
      final List<dynamic>? data =
          await appSys.api!.login(_credentials.username!.trim(), _credentials.password!.trim(), additionnalSettings: {
        "url": "",
        "demo": false,
        "mobileCasLogin": false,
      });
      if (data != null && data[0] == 1) {
        print(appSys.settings.system.chosenParser);
        print(data.toString());
        setState(() {
          _canNavigate = false;
        });
        YSnackbars.success(context, title: "Connecté !", message: data[1]);
        await Future.delayed(const Duration(seconds: 3));
        // TODO: redirect to intro
        Navigator.pushReplacementNamed(context, "/summary");
        // success
      } else {
        YSnackbars.error(context, title: "Erreur", message: data![1]);
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginPageStructure(
        backButton: _canNavigate,
        subtitle: "EcoleDirecte",
        body: Padding(
          padding: YPadding.px(YScale.s2),
          child: Column(
            children: [
              YForm(
                formKey: _formKey,
                onSubmit: submit,
                fields: [
                  YFormField(
                      properties: YFormFieldProperties(),
                      label: "Identifiant",
                      type: TextInputType.text,
                      validator: (String? value) {
                        return value == null || value.isEmpty ? 'Ce champ est obligatoire' : null;
                      },
                      onSaved: (String? value) {
                        _credentials.username = value;
                      }),
                  YFormField(
                      properties: YFormFieldProperties(),
                      label: "Mot de passe",
                      type: TextInputType.visiblePassword,
                      validator: (String? value) {
                        return value == null || value.isEmpty ? 'Ce champ est obligatoire' : null;
                      },
                      onSaved: (String? value) {
                        _credentials.password = value;
                      }),
                ],
              ),
              YVerticalSpacer(YScale.s6),
              YButton(
                text: "SE CONNECTER",
                onPressed: () {
                  submit(_formKey.currentState!.validate());
                },
                block: true,
                isLoading: _loading,
                isDisabled: !_canNavigate,
              )
            ],
          ),
        ));
  }
}
