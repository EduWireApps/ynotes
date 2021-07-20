import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'package:ynotes/ui/screens/login/content/loginTextContent.dart';
import 'package:ynotes/ui/screens/login/widgets/login_dialog.dart';
import 'package:ynotes/ui/screens/login/widgets/login_text_field.dart';
import 'package:ynotes/ui/screens/login/widgets/login_web_view.dart';
import 'package:ynotes/useful_methods.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/components.dart';

class PronoteUrlBox extends StatefulWidget {
  final TextEditingController urlCon;
  final VoidCallback callback;
  final VoidCallback longPressCallBack;

  const PronoteUrlBox({Key? key, required this.urlCon, required this.callback, required this.longPressCallBack})
      : super(key: key);

  @override
  _PronoteUrlBoxState createState() => _PronoteUrlBoxState();
}

class _PronoteUrlBoxState extends State<PronoteUrlBox> with LayoutMixin, YPageMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 1.1.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), color: theme.colors.neutral.shade300),
      child: Column(
        children: [
          LoginTextField(label: LoginPageTextContent.pronote.url.url, controller: widget.urlCon),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  print("");
                },
                child: Text(
                  LoginPageTextContent.pronote.url.forgotUrl,
                  style: TextStyle(
                      fontFamily: "Asap", color: theme.colors.neutral.shade500, decoration: TextDecoration.underline),
                ),
              ),
              Spacer(),
              YButton(
                  onPressed: () => processUrl(),
                  onLongPressed: widget.longPressCallBack,
                  text: LoginPageTextContent.pronote.url.buttonLabel)
            ],
          )
        ],
      ),
    );
  }

  ///Pronote URL autoformatter
  formatURL(String url) {
    RegExp regExp = new RegExp(
      r"(.*/pronote)(.*)",
      caseSensitive: false,
      multiLine: false,
    );
    if (regExp.hasMatch(url) && regExp.firstMatch(url)?.groupCount == 2) {
      String suffix = regExp.firstMatch(url)?.group(2) ?? "";

      RegExp suffixMatches = new RegExp(
        r"/?(mobile\.)?(.*)?",
        caseSensitive: false,
        multiLine: false,
      );
      //situation where nothing matches (might be pronote/)
      if (suffixMatches.firstMatch(suffix)?.groups([1, 2]).every((element) => element == null) ?? true) {
        CustomLogger.log("LOGIN", "A");
        suffix = "/mobile.eleve.html";
        return [0, (regExp.firstMatch(url)?.group(1) ?? "") + suffix];
      }
      //situation where only mobile. is missing
      else if (suffixMatches.firstMatch(suffix)?.group(1) == null &&
          suffixMatches.firstMatch(suffix)?.group(2) != null) {
        CustomLogger.log("LOGIN", "B");

        suffix = "/mobile." + (suffixMatches.firstMatch(suffix)?.group(2) ?? "");
        return [0, (regExp.firstMatch(url)?.group(1) ?? "") + suffix];
      }

      //situation where everything matches
      else if (suffixMatches.firstMatch(suffix)?.groups([1, 2]).every((element) => element != null) ?? false) {
        CustomLogger.log("LOGIN", "C");
        suffix = "/" +
            (suffixMatches.firstMatch(suffix)?.group(1) ?? "") +
            (suffixMatches.firstMatch(suffix)?.group(2) ?? "");

        return [1, (regExp.firstMatch(url)?.group(1) ?? "") + suffix];
      }
    } else {
      throw ("Wrong url");
    }
  }

  Future<void> processUrl() async {
    try {
      if (formatURL(widget.urlCon.text)[0] == 0) {
        setState(() {
          widget.urlCon.text = formatURL(widget.urlCon.text)[1];
        });
        CustomDialogs.showErrorSnackBar(context, LoginPageTextContent.pronote.url.reformatting, null);

        return;
      }
      if (await checkPronoteURL(widget.urlCon.text)) {
        if (await testIfPronoteCas(widget.urlCon.text)) {
          CustomLogger.log("LOGIN", "Is a pronote cas");
          //openLocalPage(YPageLocal(title: "Connexion à un ENT", child: LoginWebView(url: widget.urlCon.text)));
          var a = await Navigator.of(context).push(router(LoginWebView(url: widget.urlCon.text)));
          if (a != null) {
            Future<List> connectionData = appSys.api!.login(a["login"], a["mdp"], additionnalSettings: {
              "url": widget.urlCon.text,
              "mobileCasLogin": true,
            });
            LoginDialog(connectionData).show(context);
          }
        } else {
          widget.callback();
        }
      } else {
        CustomDialogs.showErrorSnackBar(context, "Adresse invalide", "(pas de log spécifique)");
      }
    } catch (e) {
      CustomLogger.log("LOGIN", "An error occured with the url");
      CustomLogger.error(e);
      CustomDialogs.showErrorSnackBar(context, LoginPageTextContent.pronote.url.impossibleToConnect, e.toString());
    }
  }
}
