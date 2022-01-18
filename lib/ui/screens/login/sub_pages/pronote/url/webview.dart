import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/core_new/services.dart';
import 'package:ynotes/core_new/utilities.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPronoteUrlWebviewPage extends StatefulWidget {
  const LoginPronoteUrlWebviewPage({Key? key}) : super(key: key);

  @override
  _LoginPronoteUrlWebviewPageState createState() => _LoginPronoteUrlWebviewPageState();
}

class _LoginPronoteUrlWebviewPageState extends State<LoginPronoteUrlWebviewPage> {
  InAppWebViewController? _controller;
  late String url;
  bool cookiesSet = false;
  bool authenticated = false;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  getCredentials(String credsData) {
    if (credsData.isNotEmpty) {
      Logger.logWrapped("LOGIN", "Credentials data", credsData, save: false);
      final Map<String, dynamic> decoded = json.decode(credsData);
      Logger.log("LOGIN", "(Web view) Status: ${decoded["status"]}");
      if (decoded["status"] == 0) {
        if (!authenticated) {
          Navigator.of(context).pop(decoded);
          setState(() {
            authenticated = true;
          });
        }
      } else {}
    } else {
      //This can happen if the page is not fully loaded
      Logger.log("LOGIN", "(Web view) Credentials are null");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _url = AppRouter.getArgs<String>(context);
    setState(() {
      url = _url;
    });
    final String infoUrl = ApisUtilities.getPronoteInfoUrl(url);
    return YPage(
      scrollable: false,
      appBar: YAppBar(
        title: LoginContent.pronote.url.webview.title,
        actions: [
          YIconButton(
              onPressed: () {
                YDialogs.showInfo(
                    context,
                    YInfoDialog(
                      title: LoginContent.pronote.url.webview.dialog.title,
                      body: Column(
                        children: [
                          Text(LoginContent.pronote.url.webview.dialog.body, style: theme.texts.body1),
                          YVerticalSpacer(YScale.s2),
                          YButton(
                            onPressed: () async => await launch("https://discord.gg/pRCBs22dNX"),
                            color: YColor.primary,
                            text: LoginContent.pronote.url.webview.dialog.support,
                            icon: FontAwesomeIcons.discord,
                          ),
                          YVerticalSpacer(YScale.s2),
                          YButton(
                            onPressed: () => BugReport.report(),
                            color: YColor.secondary,
                            text: LoginContent.pronote.url.webview.dialog.report,
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
                  opacity: cookiesSet ? 1 : 0,
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
                      if (!cookiesSet) {
                        Logger.log("LOGIN", "(Web view) Setting cookie");
                        // generate UUID
                        SettingsService.settings.global.uuid = const Uuid().v4();
                        await SettingsService.update();
                        // We use the window function to create a cookie
                        // Looks like this one contains an important UUID which is used by Pronote to fingerprint the device and makes sure that nobody will use this cookie on another one
                        final String script = """
                        (function(){try{
                        var lJetonCas = "", lJson = JSON.parse(document.body.innerText);
                        lJetonCas = !!lJson && !!lJson.CAS && lJson.CAS.jetonCAS;
                        document.cookie = "appliMobile=;expires=" + new Date(0).toUTCString();
                        if(!!lJetonCas) {
                        document.cookie = "validationAppliMobile="+lJetonCas+";expires=" + new Date(new Date().getTime() + (5*60*1000)).toUTCString();
                        document.cookie = "uuidAppliMobile=${SettingsService.settings.global.uuid!};expires=" + new Date(new Date().getTime() + (5*60*1000)).toUTCString();
                        document.cookie = "ielang=1036;expires=" + new Date(new Date().getTime() + (365*24*60*60*1000)).toUTCString();
                        return true;
                        } else return false;
                        } catch(e){return false;}})();
                        """;

                        // We evaluate the cookie function
                        final bool _authenticated = await (_controller?.evaluateJavascript(source: script)) ?? false;
                        setState(() {
                          cookiesSet = _authenticated;
                        });
                        if (cookiesSet) {
                          // We use this window function to redirect to the special login page
                          final String redirectScript = 'location.assign("$_url?fd=1")';
                          await (_controller!.evaluateJavascript(source: redirectScript));
                        }
                      } else {
                        Logger.log("LOGIN", "(Web view) Validating profile");
                        timer ??= Timer.periodic(const Duration(milliseconds: 2000), (_) async {
                          if (!authenticated) {
                            const String script =
                                "(function(){return window && window.loginState ? JSON.stringify(window.loginState) : '';})();";
                            final String? result = await (_controller!.evaluateJavascript(source: script));
                            if (result != null) {
                              getCredentials(result);
                            }
                          } else {
                            if (timer != null && !timer!.isActive) {
                              timer?.cancel();
                            }
                          }
                        });
                      }
                    },
                    onProgressChanged: (InAppWebViewController controller, int progress) {},
                  ),
                ),
                if (!cookiesSet)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(LoginContent.pronote.url.webview.connecting, style: theme.texts.body1),
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
}
