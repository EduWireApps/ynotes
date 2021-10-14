import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/routing_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPronoteUrlWebviewPageArguments {
  final String url;

  const LoginPronoteUrlWebviewPageArguments(this.url);
}

class LoginPronoteUrlWebviewPage extends StatefulWidget {
  const LoginPronoteUrlWebviewPage({Key? key}) : super(key: key);

  @override
  _LoginPronoteUrlWebviewPageState createState() => _LoginPronoteUrlWebviewPageState();
}

enum _AuthState { setCookie, authenticate, test }

class _LoginPronoteUrlWebviewPageState extends State<LoginPronoteUrlWebviewPage> {
  InAppWebViewController? _controller;
  late String url;
  Map? loginStatus;
  bool authenticated = false;
  _AuthState step = _AuthState.setCookie;

  //Checking the profile and getting the credentials
  authAndValidateProfile() async {
    CustomLogger.log("LOGIN", "(Web view) Validating profile");

    Timer(const Duration(milliseconds: 1500), () async {
      setState(() {
        authenticated = true;
      });
      const String script =
          "(function(){return window && window.loginState ? JSON.stringify(window.loginState) : '';})();";
      final String? result = await (_controller!.evaluateJavascript(source: script));
      getCredentials(result);
      if (loginStatus != null) {
        setState(() {
          step = _AuthState.test;
        });
        await _controller!
            .loadUrl(urlRequest: URLRequest(url: Uri.parse(url + "?fd=1&bydlg=A6ABB224-12DD-4E31-AD3E-8A39A1C2C335")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = RoutingUtils.getArgs<LoginPronoteUrlWebviewPageArguments>(context);
    setState(() {
      url = args.url;
    });
    final String infoUrl = getInfoUrl(url);
    return YPage(
      scrollable: false,
      appBar: YAppBar(
        title: "Connexion à l'ENT",
        actions: [
          YIconButton(
              onPressed: () {
                YDialogs.showInfo(
                    context,
                    YInfoDialog(
                      title: "Je ne parviens pas à me connecter",
                      body: Column(
                        children: [
                          Text(
                              "Impossible de se connecter, une page blanche ou une question ? Rejoignez le serveur Discord de support pour obtenir une réponse. \n\nSi votre problème est une simple erreur d'affichage ou ne vous empêche pas de vous connecter signalez l'erreur avec l'outil de rapport ci-dessous.",
                              style: theme.texts.body1),
                          YVerticalSpacer(YScale.s2),
                          YButton(
                            onPressed: () async => await launch("https://discord.gg/pRCBs22dNX"),
                            color: YColor.primary,
                            text: "Besoin d'une assistance rapide",
                            icon: FontAwesomeIcons.discord,
                          ),
                          YVerticalSpacer(YScale.s2),
                          YButton(
                            onPressed: () => Wiredash.of(context)!.show(),
                            color: YColor.secondary,
                            text: "Signaler un problème mineur",
                            icon: MdiIcons.forum,
                          )
                        ],
                      ),
                      confirmLabel: "Fermer",
                    ));
              },
              icon: MdiIcons.lifebuoy),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Opacity(
                  opacity: authenticated ? 1 : 0,
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(infoUrl),
                    ),

                    ///1) We open a page with the serverUrl + weird string hardcoded
                    initialOptions: InAppWebViewGroupOptions(
                        android: AndroidInAppWebViewOptions(useHybridComposition: true),
                        crossPlatform: InAppWebViewOptions(
                            supportZoom: true,
                            javaScriptEnabled: true,
                            allowFileAccessFromFileURLs: true,
                            userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:92.0) Gecko/20100101 Firefox/92.0",
                            allowUniversalAccessFromFileURLs: true)),
                    onWebViewCreated: (InAppWebViewController controller) {
                      _controller = controller;
                      //Clear cookies
                      _controller!.clearCache();
                    },
                    onConsoleMessage: (a, b) {},

                    onLoadHttpError: (d, c, a, f) {},
                    onLoadError: (a, b, c, d) {},
                    onLoadStop: (controller, url) async {
                      await stepper();
                    },
                    onProgressChanged: (InAppWebViewController controller, int progress) {},
                  ),
                ),
                if (!authenticated)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Connexion en cours...", style: theme.texts.body1),
                        YVerticalSpacer(YScale.s2),
                        const SizedBox(width: 250, child: YLinearProgressBar())
                      ],
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getCredentials(String? credsData) {
    if (credsData != null && credsData.isNotEmpty) {
      CustomLogger.logWrapped("LOGIN", "Credentials data", credsData);
      final Map temp = json.decode(credsData);
      CustomLogger.log("LOGIN", "(Web view) Status: ${temp["status"]}");
      if (temp["status"] == 0) {
        loginStatus = temp;
        Navigator.of(context).pop(loginStatus);
      } else {}
    } else {
      //This can happen if the page is not fully loaded
      CustomLogger.log("LOGIN", "(Web view) Credentials are null");
    }
  }

  // TODO: Test in beta if that's required
  //IDK if it's still useful, but It redirects the user to the Pronote official page and log in
  loginTest() async {
    CustomLogger.log("LOGIN", "(Web view) Login test");
    Timer(const Duration(milliseconds: 1500), () async {
      const String script = 'if(!window.messageData) /*window.messageData = [];*/';
      await _controller!.evaluateJavascript(source: script);
    });
  }

  //We set the login cookie here
  setCookie() async {
    CustomLogger.log("LOGIN", "(Web view) Setting cookie");
    //generate UUID
    appSys.settings.system.uuid = const Uuid().v4();
    appSys.saveSettings();
    //We use the window function to create a cookie
    //Looks like this one contains an important UUID which is used by Pronote to fingerprint the device and makes sure that nobody will use this cookie on another one
    final String script = """
    (function(){try{
        var lJetonCas = "", lJson = JSON.parse(document.body.innerText);
        lJetonCas = !!lJson && !!lJson.CAS && lJson.CAS.jetonCAS;
        document.cookie = "appliMobile=;expires=" + new Date(0).toUTCString();
        if(!!lJetonCas) {
        document.cookie = "validationAppliMobile="+lJetonCas+";expires=" + new Date(new Date().getTime() + (5*60*1000)).toUTCString();
        document.cookie = "uuidAppliMobile=${appSys.settings.system.uuid!};expires=" + new Date(new Date().getTime() + (5*60*1000)).toUTCString();
        document.cookie = "ielang=1036;expires=" + new Date(new Date().getTime() + (365*24*60*60*1000)).toUTCString();
        return true;
        } else return false;
        } catch(e){return false;}})();
        """;

    //We evaluate the cookie function
    final bool? _authenticated = await (_controller?.evaluateJavascript(source: script));
    if (_authenticated != null && _authenticated) {
      //We use this window function to redirect to the special login page
      String authFunction = 'location.assign("' + url + '?fd=1")';
      //We logically set the next step before redirecting the page
      setState(() {
        step = _AuthState.authenticate;
      });
      await (_controller!.evaluateJavascript(source: authFunction));
      stepper();
    }
  }

  ///Called at each page load stop
  ///Represents login steps
  stepper() async {
    switch (step) {
      case _AuthState.setCookie:
        {
          await setCookie();
        }
        break;
      case _AuthState.authenticate:
        {
          await authAndValidateProfile();
        }
        break;
      case _AuthState.test:
        {
          await loginTest();
        }
    }
  }
}
