import 'package:flutter/material.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/utilities.dart';

class _Credentials {
  String username;
  String password;
  String url;

  _Credentials({this.username = "", this.password = "", required this.url});
}

class LoginForm extends StatefulWidget {
  final String subtitle;
  final String url;

  const LoginForm({Key? key, required this.subtitle, this.url = ""}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late final _Credentials _credentials = _Credentials(url: widget.url);
  bool _canNavigate = true;

  Future<void> submit(bool b) async {
    setState(() {
      _loading = true;
    });
    if (b) {
      _formKey.currentState!.save();
      final List<dynamic>? data =
          await appSys.api!.login(_credentials.username.trim(), _credentials.password.trim(), additionnalSettings: {
        "url": _credentials.url.trim(),
        "demo": false,
        "mobileCasLogin": false,
      });
      if (data != null && data[0] == 1) {
        setState(() {
          _canNavigate = false;
        });
        YSnackbars.success(context, title: "Connecté !", message: data[1]);
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pushReplacementNamed(context, "/terms");
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
      subtitle: widget.subtitle,
      body: Column(
        children: [
          YForm(
            formKey: _formKey,
            onSubmit: submit,
            autoSubmit: _canNavigate,
            fields: [
              YFormField(
                  properties: YFormFieldProperties(),
                  label: "Identifiant",
                  type: YFormFieldInputType.text,
                  validator: (String? value) {
                    return value == null || value.isEmpty ? 'Ce champ est obligatoire' : null;
                  },
                  onSaved: (String? value) {
                    _credentials.username = value ?? "";
                  }),
              YFormField(
                  properties: YFormFieldProperties(),
                  label: "Mot de passe",
                  type: YFormFieldInputType.password,
                  validator: (String? value) {
                    return value == null || value.isEmpty ? 'Ce champ est obligatoire' : null;
                  },
                  onSaved: (String? value) {
                    _credentials.password = value ?? "";
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
    );
  }
}
