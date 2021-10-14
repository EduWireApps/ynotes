import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/routing_utils.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/url/form.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/url/webview.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPronoteUrlPageArguments {
  final String url;

  const LoginPronoteUrlPageArguments(this.url);
}

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
            Navigator.pushNamed(context, "/login/pronote/url/form",
                arguments: LoginPronoteUrlFormPageArguments(response.url));
            break;
          case _Route.webview:
            final dynamic res = await Navigator.pushNamed(context, "/login/pronote/url/webview",
                arguments: LoginPronoteUrlWebviewPageArguments(response.url));
            if (res != null) {
              final List<dynamic>? data = await appSys.api!.login(res["login"], res["mdp"], additionnalSettings: {
                "url": response.url,
                "mobileCasLogin": true,
              });
              if (data != null && data[0] == 1) {
                setState(() {
                  _canNavigate = false;
                });
                YSnackbars.success(context, title: "Connecté !", message: data[1]);
                await Future.delayed(const Duration(seconds: 3));
                Navigator.pushReplacementNamed(context, "/terms");
              } else {
                YSnackbars.error(context, title: "Erreur", message: data![1]);
              }
            }
            break;
        }
      } else {
        YSnackbars.error(context, title: "Erreur", message: response.message!);
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = RoutingUtils.getArgs<LoginPronoteUrlPageArguments?>(context);
    if (args != null) {
      setState(() {
        _url = args.url;
      });
    }
    return LoginPageStructure(
        subtitle: "Par URL Pronote",
        body: Column(
          children: [
            YForm(
              formKey: _formKey,
              onSubmit: submit,
              fields: [
                YFormField(
                  type: YFormFieldInputType.url,
                  defaultValue: args?.url,
                  label: "URL Pronote",
                  properties: YFormFieldProperties(),
                  onSaved: (String? value) {
                    _url = value ?? "";
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Ce champ est obligatoire";
                    }
                    final RegExp urlOrIpExp = RegExp(
                        r"^(((http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6})|(\b25[0-5]|\b2[0-4][0-9]|\b[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}(\:\b[0-9]{1,4})?)\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)?$");
                    if (!urlOrIpExp.hasMatch(value)) {
                      return "Url invalide";
                    }
                  },
                )
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
        ));
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
        CustomLogger.saveLog(object: "LOGIN", text: "(Pronote URL) Nothing matches");
        suffix = "/mobile.eleve.html";
        return (regExp.firstMatch(url)?.group(1) ?? "") + suffix;
      }
      //situation where only mobile. is missing
      else if (suffixMatches.firstMatch(suffix)?.group(1) == null &&
          suffixMatches.firstMatch(suffix)?.group(2) != null) {
        CustomLogger.saveLog(object: "LOGIN", text: "(Pronote URL) 'mobile.' is missing.");
        suffix = "/mobile." + (suffixMatches.firstMatch(suffix)?.group(2) ?? "");
        return (regExp.firstMatch(url)?.group(1) ?? "") + suffix;
      }

      //situation where everything matches
      else if (suffixMatches.firstMatch(suffix)?.groups([1, 2]).every((element) => element != null) ?? false) {
        CustomLogger.saveLog(object: "LOGIN", text: "(Pronote URL) Everything matches");
        suffix = "/" +
            (suffixMatches.firstMatch(suffix)?.group(1) ?? "") +
            (suffixMatches.firstMatch(suffix)?.group(2) ?? "");

        return (regExp.firstMatch(url)?.group(1) ?? "") + suffix;
      }
    }
    CustomLogger.saveLog(object: "LOGIN", text: "(Pronote URL) Invalid url.");
    return null;
  }

  Future<_ProcessUrlResponse> processUrl(BuildContext context, String url) async {
    final String? res = _formatUrl(url);
    final bool isValid = res != null;
    if (isValid) url = res;
    if (isValid && await checkPronoteURL(url)) {
      final bool isCas = await testIfPronoteCas(url);
      CustomLogger.saveLog(object: "LOGIN", text: "(Pronote URL) Is CAS: $isCas");
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
}

enum _Route { form, webview }

class _ProcessUrlResponse {
  final _Route? route;
  final String? message;
  final String url;

  const _ProcessUrlResponse({this.route, this.message, this.url = ""});
}
