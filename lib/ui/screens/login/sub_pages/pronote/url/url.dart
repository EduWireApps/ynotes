import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/url/form.dart';
import 'package:ynotes/ui/screens/login/w/widgets.dart';
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

  Future<void> submit(bool b) async {
    setState(() {
      _loading = true;
    });
    if (b) {
      _formKey.currentState!.save();
      final _ProcessUrlResponse? response = await _UrlManager.processUrl(context, _url);
      print(response);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  label: "URL Pronote",
                  properties: YFormFieldProperties(),
                  onSaved: (String? value) {
                    _url = value ?? "";
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Ce champ est obligatoire";
                    }
                    final RegExp urlExp =
                        RegExp(r"(http|ftp|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?");
                    if (!urlExp.hasMatch(value)) {
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
}

class _FormatUrlResponse {
  final bool valid;
  final String? url;

  const _FormatUrlResponse({this.valid = true, this.url = ""});
}

class _ProcessUrlResponse {
  final bool valid;
  final String message;

  const _ProcessUrlResponse({required this.valid, required this.message});
}

class _UrlManager {
  const _UrlManager._();

  static _FormatUrlResponse _formatUrl(String url) {
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
        return _FormatUrlResponse(url: (regExp.firstMatch(url)?.group(1) ?? "") + suffix);
      }
      //situation where only mobile. is missing
      else if (suffixMatches.firstMatch(suffix)?.group(1) == null &&
          suffixMatches.firstMatch(suffix)?.group(2) != null) {
        CustomLogger.saveLog(object: "LOGIN", text: "(Pronote URL) 'mobile.' is missing.");
        suffix = "/mobile." + (suffixMatches.firstMatch(suffix)?.group(2) ?? "");
        return _FormatUrlResponse(url: (regExp.firstMatch(url)?.group(1) ?? "") + suffix);
      }

      //situation where everything matches
      else if (suffixMatches.firstMatch(suffix)?.groups([1, 2]).every((element) => element != null) ?? false) {
        CustomLogger.saveLog(object: "LOGIN", text: "(Pronote URL) Everything matches");
        suffix = "/" +
            (suffixMatches.firstMatch(suffix)?.group(1) ?? "") +
            (suffixMatches.firstMatch(suffix)?.group(2) ?? "");

        return _FormatUrlResponse(url: (regExp.firstMatch(url)?.group(1) ?? "") + suffix);
      }
    }
    CustomLogger.saveLog(object: "LOGIN", text: "(Pronote URL) Invalid url.");
    return const _FormatUrlResponse(valid: false);
  }

  static Future<_ProcessUrlResponse?> processUrl(BuildContext context, String url) async {
    final _FormatUrlResponse res = _formatUrl(url);
    final bool isValid = await checkPronoteURL(url);
    if (res.valid && isValid) {
      final bool isCas = await testIfPronoteCas(url);
      CustomLogger.saveLog(object: "LOGIN", text: "(Pronote URL) Is CAS: $isCas");
      if (isCas) {
        Navigator.pushNamed(context, "/login/pronote/url/webview");
        return null;
      } else {
        // TODO: redirect to /login/url/form with form like ED
        Navigator.pushNamed(context, "/login/pronote/url/form", arguments: LoginPronoteUrlFormPageArguments(url));
        return null;
      }
    } else {
      return const _ProcessUrlResponse(valid: false, message: "Impossible de se connecter à cette adresse.");
      // YSnackbars.error(context, title: "Erreur", message: "Impossible de se connecter à cette adresse");
    }
  }
}
