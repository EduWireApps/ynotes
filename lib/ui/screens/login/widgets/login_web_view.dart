import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';

// ignore: must_be_immutable
class LoginWebView extends StatefulWidget {
  final String? url;
  final String? spaceUrl;

  LoginWebView({Key? key, this.url, this.spaceUrl}) : super(key: key);
  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  InAppWebViewController? _controller;

  var loginData;
  late Map currentProfile;
  //locals, but shouldn't be obviously

  Map? loginStatus;
  String? serverUrl;
  String? espaceUrl;
  bool auth = false;
  int step = 1;

  //Checking the profile and getting the credentials
  authAndValidateProfile() async {
    CustomLogger.log("LOGIN", "(Web view) Validating profile");

    Timer(new Duration(milliseconds: 1500), () async {
      setState(() {
        auth = true;
      });

      //We use this window function to get the credentials
      String loginDataProcess =
          "(function(){return window && window.loginState ? JSON.stringify(window.loginState) : \'\';})();";
      String? loginDataProcessResult = await (_controller!.evaluateJavascript(source: loginDataProcess));
      //We are finally parsing the credentials, hurray !
      getCreds(loginDataProcessResult);
      if (loginStatus != null) {
        setState(() {
          step = 3;
        });
        //url: widget.url + "?fd=1&bydlg=A6ABB224-12DD-4E31-AD3E-8A39A1C2C335"
        //A weird URL
        await _controller!.loadUrl(
            urlRequest: URLRequest(url: Uri.parse(widget.url! + "?fd=1&bydlg=A6ABB224-12DD-4E31-AD3E-8A39A1C2C335")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse(getRootAddress(widget.url)[0] +
                    (widget.url![widget.url!.length - 1] == "/" ? "" : "/") +
                    "InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4")),

            ///1) We open a page with the serverUrl + weird string hardcoded
            initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(useHybridComposition: true),
                crossPlatform: InAppWebViewOptions(
                    supportZoom: true,
                    javaScriptEnabled: true,
                    allowFileAccessFromFileURLs: true,
                    userAgent:
                        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36 OPR/38.0.2220.41",
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
          Align(
            alignment: Alignment.bottomRight,
            child: _buildFloatingButton(context),
          ),
          if (!auth)
            Container(
              width: screenSize.size.width,
              height: screenSize.size.height,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!kIsWeb && Platform.isLinux)
                      Text(
                        "La connexion par ENT n'est pas encore supportée sur Linux...",
                        style: TextStyle(fontFamily: "Asap", color: Colors.red),
                      ),
                    if (!kIsWeb && !Platform.isLinux)
                      Text(
                        "Patientez... nous vous connectons à l'ENT",
                        style: TextStyle(fontFamily: "Asap"),
                      ),
                    CustomButtons.materialButton(context, null, null, () {
                      Navigator.of(context).pop();
                    }, label: "Quitter")
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  //Here, we parse the credentials
  getCreds(String? credsData) {
    if (credsData != null && credsData.length > 0) {
      CustomLogger.logWrapped("LOGIN", "Credentials data", credsData);
      Map temp = json.decode(credsData);
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

  //IDK if it's still useful, but It redirects the user to the Pronote official page and log in
  loginTest() async {
    CustomLogger.log("LOGIN", "(Web view) Login test");
    Timer(new Duration(milliseconds: 1500), () async {
      String toexecute = 'if(!window.messageData) /*window.messageData = [];*/';
      await _controller!.evaluateJavascript(source: toexecute);
    });
  }

  //We set the login cookie here
  setCookie() async {
    CustomLogger.log("LOGIN", "(Web view) Setting cookie");
    //generate UUID
    appSys.settings.system.uuid = Uuid().v4();
    appSys.saveSettings();
    //We use the window function to create a cookie
    //Looks like this one contains an important UUID which is used by Pronote to fingerprint the device and makes sure that nobody will use this cookie on another one
    String cookieFunction = '(function(){try{' +
        'var lJetonCas = "", lJson = JSON.parse(document.body.innerText);' +
        'lJetonCas = !!lJson && !!lJson.CAS && lJson.CAS.jetonCAS;' +
        'document.cookie = "appliMobile=;expires=" + new Date(0).toUTCString();' +
        'if(!!lJetonCas) {' +
        'document.cookie = "validationAppliMobile="+lJetonCas+";expires=" + new Date(new Date().getTime() + (5*60*1000)).toUTCString();' +
        'document.cookie = "uuidAppliMobile=' +
        appSys.settings.system.uuid! +
        ';expires=" + new Date(new Date().getTime() + (5*60*1000)).toUTCString();' +
        'document.cookie = "ielang=' +
        "1036" +
        ';expires=" + new Date(new Date().getTime() + (365*24*60*60*1000)).toUTCString();' +
        'return "ok";' +
        '} else return "ko";' +
        '} catch(e){return "ko";}})();';

    //We evaluate the cookie function
    String? cookieFunctionResult = await (_controller?.evaluateJavascript(source: cookieFunction));
    //If it contains "ok" we are logged in
    if (cookieFunctionResult == "ok") {
      //We use this window function to redirect to the special login page
      String authFunction = 'location.assign("' + widget.url! + '?fd=1")';
      //We logically set the next step before redirecting the page
      setState(() {
        step = 2;
      });
      await (_controller!.evaluateJavascript(source: authFunction));
      stepper();
    }
  }

  ///Called at each page load stop
  ///Represents login steps
  stepper() async {
    switch (step) {
      case 1:
        {
          await setCookie();
        }
        break;
      case 2:
        {
          await authAndValidateProfile();
        }
        break;
      case 3:
        {
          await loginTest();
        }
    }
  }

  _buildFloatingButton(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
      child: FloatingActionButton(
        heroTag: "btn2",
        backgroundColor: Colors.transparent,
        child: Container(
          width: 90,
          height: 90,
          child: Center(
            child: Icon(
              MdiIcons.exitRun,
              size: 40,
            ),
          ),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff100A30)),
        ),
        onPressed: () async {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
