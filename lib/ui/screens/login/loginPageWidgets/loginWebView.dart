import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/core/apis/Pronote/PronoteCas.dart';

class LoginWebView extends StatefulWidget {
  final String url;
  InAppWebViewController controller;

  LoginWebView({Key key, this.url, this.controller}) : super(key: key);
  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  //locals, but shouldn't be obviously
  String location;
  Map loginStatus;
  String serverUrl;
  String espaceUrl;
  _buildFloatingButton(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return FloatingActionButton(
      heroTag: "btn2",
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenSize.size.width / 5 * 0.8,
        height: screenSize.size.width / 5 * 0.8,
        child: Icon(
          Icons.add,
          size: screenSize.size.width / 5 * 0.5,
        ),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff100A30)),
      ),
      onPressed: () async {
        await widget.controller.loadUrl(
            url:
                "https://0782540m.index-education.net/pronote/InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4");
        String toexecute = '(function(){try{' +
            'var lJetonCas = "", lJson = JSON.parse(document.body.innerText);' +
            'lJetonCas = !!lJson && !!lJson.CAS && lJson.CAS.jetonCAS;' +
            'document.cookie = "appliMobile=;expires=" + new Date(0).toUTCString();' +
            'if(!!lJetonCas) {' +
            'document.cookie = "validationAppliMobile="+lJetonCas+";expires=" + new Date(new Date().getTime() + (5*60*1000)).toUTCString();' +
            'document.cookie = "uuidAppliMobile=' +
            "8798213546" +
            ';expires=" + new Date(new Date().getTime() + (5*60*1000)).toUTCString();' +
            'document.cookie = "ielang=' +
            //Langage to use
            /*fr: 1036,
              it: 1040,
              en: 1033,
              es: 3082*/
            "1036" +
            ';expires=" + new Date(new Date().getTime() + (365*24*60*60*1000)).toUTCString();' +
            'return "ok";' +
            '} else return "ko";' +
            '} catch(e){return "ko "+e+lJson;}})();';
        String a = await widget.controller.evaluateJavascript(source: toexecute);
        print(a);
        String cookieRequest =
            'location.assign("' + "https://0782540m.index-education.net/pronote/mobile.eleve.html" + '?fd=1")';
        String b = await widget.controller.evaluateJavascript(source: cookieRequest);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          InAppWebView(
            initialUrl: widget.url,
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
              debuggingEnabled: true,
            )),
            onWebViewCreated: (InAppWebViewController controller) {
              widget.controller = controller;
              //Clear cookies
              controller.clearCache();
            },
            onLoadStart: (InAppWebViewController controller, String url) {},
            onLoadStop: (InAppWebViewController controller, String url) async {
              var uuid = Uuid();

              //Injected to get the server metas
              String locationProcess = "(function(){return JSON.stringify(location);})();";

              //Injected after successful login to get the credentials and... useful stuff I guess
              String loginDataProcess =
                  "(function(){return window && window.loginState ? JSON.stringify(window.loginState) : \'\';})();";
              String test = "(function(){return document.body.innerText;})()";

              await controller.evaluateJavascript(source: loginDataProcess);
              String locationProcessResult = await controller.evaluateJavascript(source: locationProcess);

              //Execute a little bit later
              //Get credentials and login stuff
              Timer(new Duration(seconds: 1), () async {
                String loginDataProcessResult = await controller.evaluateJavascript(source: loginDataProcess);
                getCreds(loginDataProcessResult);
                String validationProcess =
                    "(function(){window.hookAccesDepuisAppli = function(){this.passerEnModeValidationAppliMobile('" +
                        (loginStatus != null ? loginStatus["login"].replaceAll("'", "\\'") : "") +
                        '\', \'' +
                        "8798213546" +
                        "')};return \'\';})()";
                print(validationProcess);
                await controller.evaluateJavascript(source: validationProcess);

                interpreteLogin(loginDataProcessResult);
              });

              //Interprete location to get URLs and other useful stuff
              interpreteLocation(locationProcessResult);
            },
            onProgressChanged: (InAppWebViewController controller, int progress) {},
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _buildFloatingButton(context),
          )
        ],
      ),
    );
  }

  getCreds(String credsData) {
    if (credsData != null && credsData.length > 0) {
      printWrapped(credsData);
      Map temp = json.decode(credsData);
      print(temp["status"]);
      if (temp != null && temp["status"] == 0) {
        loginStatus = temp;
        print(loginStatus);
      }
    }
  }

  ///1) Redirected to the first URL (CAS login)
  ///2) User enters its credentials
  ///3) We get
  interpreteLogin(String data) {
    print(data);
  }

  interpreteLocation(String data) {
    if (data != null) {
      Map dataLoc = json.decode(data);
      if (location == null) {
        location = dataLoc["host"];
        print("New host");
        printWrapped(data);
      } else if (location != dataLoc["host"]) {
        print("Leaving");
        print(data);
        serverUrl = dataLoc["protocol"] + '//' + dataLoc["host"] + dataLoc["pathname"];
        espaceUrl = dataLoc["espace"];
        print(serverUrl);
        print(espaceUrl);
      }
    }
  }

  getCookie() {}
  validationProcess() {
    //I have to get an address like that
    //https://0782540m.index-education.net/pronote/InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4
  }
}
