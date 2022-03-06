import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/extensions.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPronoteUrlPage extends StatefulWidget {
  const LoginPronoteUrlPage({Key? key}) : super(key: key);

  @override
  State<LoginPronoteUrlPage> createState() => _LoginPronoteUrlPageState();
}

class _LoginPronoteUrlPageState extends State<LoginPronoteUrlPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _url = "";
  bool _loading = false;
  bool _canNavigate = true;

  @override
  Widget build(BuildContext context) {
    final url = AppRouter.getArgs<String?>(context);
    if (url != null) {
      setState(() {
        _url = url;
      });
    }
    return LoginPageStructure(
        subtitle: LoginContent.pronote.url.subtitle,
        body: Column(
          children: [
            YForm(
              formKey: _formKey,
              onSubmit: submit,
              fields: [
                YFormField(
                  type: YFormFieldInputType.url,
                  defaultValue: _url,
                  label: LoginContent.pronote.url.fieldLabel,
                  properties: YFormFieldProperties(),
                  onSaved: (String? value) {
                    _url = value ?? "";
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return LoginContent.pronote.url.requiredField;
                    }
                    final RegExp urlOrIpExp = RegExp(
                        r"^(((http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6})|(\b25[0-5]|\b2[0-4][0-9]|\b[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}(\:\b[0-9]{1,4})?)\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)?$");
                    if (!urlOrIpExp.hasMatch(value)) {
                      return LoginContent.pronote.url.errorMessage;
                    }
                  },
                )
              ],
            ),
            YVerticalSpacer(YScale.s6),
            YButton(
              text: LoginContent.pronote.url.logIn,
              onPressed: () {
                submit(_formKey.currentState!.validate());
              },
              block: true,
              isLoading: _loading,
              isDisabled: !_canNavigate,
            )
          ],
        ));
  }

  Future<_ProcessUrlResponse> processUrl(BuildContext context, String url) async {
    final String? res = _formatUrl(url);
    final bool isValid = res != null;
    if (isValid) url = res;
    if (isValid && await ApisUtilities.checkPronoteURL(url)) {
      final bool isCas = await ApisUtilities.checkPronoteCas(url);
      Logger.log("LOGIN", "(Pronote URL) Is CAS: $isCas");
      if (isCas) {
        if (kIsWeb || Platform.isWindows || Platform.isLinux) {
          return _ProcessUrlResponse(
              message: "Impossible de se connecter avec une webview sur ${Platform.operatingSystem.capitalize()}");
        }
        return _ProcessUrlResponse(route: _Route.webview, url: url);
      } else {
        return _ProcessUrlResponse(route: _Route.form, url: url);
      }
    } else {
      return const _ProcessUrlResponse(message: "Impossible de se connecter à cette adresse.");
    }
  }

  Future<void> submit(bool b) async {
    setState(() {
      _loading = true;
    });
    if (b) {
      _formKey.currentState!.save();
      final _ProcessUrlResponse response = await processUrl(context, _url);
      if (response.message == null) {
        switch (response.route!) {
          case _Route.form:
            Navigator.pushNamed(context, "/login/pronote/url/form", arguments: response.url);
            break;
          case _Route.webview:
            final dynamic res =
                await Navigator.pushNamed(context, "/login/pronote/url/webview", arguments: response.url);
            if (res != null) {
              final res0 = await schoolApi.authModule.login(username: res["login"], password: res["mdp"], parameters: {
                "url": response.url,
                "mobileCasLogin": true,
              });
              if (res0.hasError) {
                YSnackbars.error(context, title: LoginContent.pronote.url.error, message: res0.error!);
              } else {
                setState(() {
                  _canNavigate = false;
                });
                YSnackbars.success(context, title: LoginContent.pronote.url.connected, message: res0.data!);
                await Future.delayed(const Duration(seconds: 3));
                Navigator.pushReplacementNamed(context, "/terms");
              }
            }
            break;
        }
      } else {
        YSnackbars.error(context, title: LoginContent.pronote.url.error, message: response.message!);
      }
    }
    setState(() {
      _loading = false;
    });
  }

  String? _formatUrl(String url) {
    final bool isIp = double.tryParse(url[0]) != null;
    if (isIp) {
      url = "http://$url";
    }
    final RegExp regExp = RegExp(
      r"(.*/pronote)(.*)",
      caseSensitive: false,
      multiLine: false,
    );
    if (regExp.hasMatch(url) && regExp.firstMatch(url)?.groupCount == 2) {
      String suffix = regExp.firstMatch(url)?.group(2) ?? "";

      final RegExp suffixMatches = RegExp(
        r"/?(mobile\.)?(.*)?",
        caseSensitive: false,
        multiLine: false,
      );
      //situation where nothing matches (might be pronote/)
      if (suffixMatches.firstMatch(suffix)?.groups([1, 2]).every((element) => element == null) ?? true) {
        Logger.log("LOGIN", "(Pronote URL) Nothing matches");
        suffix = "/mobile.eleve.html";
        return (regExp.firstMatch(url)?.group(1) ?? "") + suffix;
      }
      //situation where only mobile. is missing
      else if (suffixMatches.firstMatch(suffix)?.group(1) == null &&
          suffixMatches.firstMatch(suffix)?.group(2) != null) {
        Logger.log("LOGIN", "(Pronote URL) 'mobile.' is missing.");
        suffix = "/mobile." + (suffixMatches.firstMatch(suffix)?.group(2) ?? "");
        return (regExp.firstMatch(url)?.group(1) ?? "") + suffix;
      }

      //situation where everything matches
      else if (suffixMatches.firstMatch(suffix)?.groups([1, 2]).every((element) => element != null) ?? false) {
        Logger.log("LOGIN", "(Pronote URL) Everything matches");
        suffix = "/" +
            (suffixMatches.firstMatch(suffix)?.group(1) ?? "") +
            (suffixMatches.firstMatch(suffix)?.group(2) ?? "");

        return (regExp.firstMatch(url)?.group(1) ?? "") + suffix;
      }
    }
    Logger.log("LOGIN", "(Pronote URL) Invalid url.");
    return null;
  }
}

class _ProcessUrlResponse {
  final _Route? route;
  final String? message;
  final String url;

  const _ProcessUrlResponse({this.route, this.message, this.url = ""});
}

enum _Route { form, webview }
