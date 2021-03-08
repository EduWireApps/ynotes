import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/core/apis/Pronote.dart';
import 'package:ynotes/core/apis/Pronote/PronoteCas.dart';
import 'package:ynotes/main.dart';

class LoginWebView extends StatefulWidget {
  final String url;
  InAppWebViewController controller;

  LoginWebView({Key key, this.url, this.controller}) : super(key: key);
  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  var loginData;
  Map currentProfile;
  //locals, but shouldn't be obviously

  String location;
  Map loginStatus;
  String serverUrl;
  String espaceUrl;

  int step = 1;
  _buildText(String text) {
    return SelectableText(text);
  }

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
        await APIPronote(offline).login("mbequet", loginStatus["mdp"],
            url:
                "https://0782540m.index-education.net/pronote/mobile.eleve.html?fd=1&bydlg=A6ABB224-12DD-4E31-AD3E-8A39A1C2C335",
            cas: "aucun");
        await APIPronote(offline).login("demonstration", "pronotevs",
            url: "https://demo.index-education.net/pronote/eleve.html", cas: "aucun");
        /* await widget.controller.loadUrl(
            url:
                "https://0782540m.index-education.net/pronote/InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4");

        String toexecute2 = '(function(){try{' +
            (true
                ? 'document.cookie = "appliMobile=1;expires=" + new Date(new Date().getTime() + (365*24*60*60*1000)).toUTCString();'
                : '') +
            'document.cookie = "ielang=' +
            "1036" +
            ';expires=" + new Date(new Date().getTime() + (365*24*60*60*1000)).toUTCString();' +
            'return "ok";' +
            '}catch(e){return JSON.stringify(e);}})();';
        String b = await widget.controller.evaluateJavascript(source: toexecute2);
        print(b);
        await widget.controller.loadUrl(
            url:
                "https://0782540m.index-education.net/pronote/mobile.eleve.html?fd=1&bydlg=A6ABB224-12DD-4E31-AD3E-8A39A1C2C335");*/

        /*String joker = 'if (IE.fModule) {' +
            '  if (GApplication.initApp) {' +
            '    GApplication.initApp({' +
            '      estAppliMobile : true,' +
            '      avecExitApp : true,' +
            '      login : \'' +
            "mbequet".replaceAll("'", "\\'") +
            '\',' +
            '      mdp : \'' +
            "A16D8E2CD73DA925E638F96C46C729833CBA0210E2AE6194F6882C4178E152C1A7B8A0E6F401D038B48A24266C934E29" +
            '\',' +
            '      uuid : \'' +
            randomUUID +
            '\',' +
            '    })' +
            '  }' +
            '} else {' +
            '  Invocateur.abonner(Invocateur.events.modificationPresenceUtilisateur, function(aPresence){' +
            '    if (!aPresence) {' +
            '      Invocateur.evenement (Invocateur.events.modificationPresenceUtilisateur, true);' +
            '    }' +
            '  }, null);' +
            '  GApplication.estAppliMobile = true;' +
            '  GApplication.infoAppliMobile = {' +
            '    avecExitApp:true' +
            '  };' +
            '  if(GApplication.smartAppBanner) \$(\'#\'+GApplication.smartAppBanner.id.escapeJQ()).remove();' +
            '  GInterface.traiterEvenementValidation(\'' +
            "mbequet".replaceAll("'", "\\'") +
            '\', \'' +
            "A16D8E2CD73DA925E638F96C46C729833CBA0210E2AE6194F6882C4178E152C1A7B8A0E6F401D038B48A24266C934E29" +
            '\', null, \'' +
            randomUUID +
            '\');' +
            '}';
        String amiajoketou = await widget.controller.evaluateJavascript(source: joker);
        print(amiajoketou);*/
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
            ///1) We open a page with the serverUrl + weird string hardcoded
            initialUrl:
                "https://0782540m.index-education.net/pronote/InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4",
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
              /*Timer(new Duration(milliseconds: 500), () async {
                String toexecute = 'if(!window.messageData) window.messageData = [];' +
                    'window._finLoadingScriptAppliMobile = function(){' +
                    '  messageData.push({action: \'load\'});' +
                    '};' +
                    'if(document.querySelectorAll(\'.conteneur\').length === 1){' +
                    '  messageData.push({action: \'errorMsg\', msg: document.querySelectorAll(\'.conteneur\')[0].innerText});' +
                    '}' +
                    'var isError = document.body.textContent.match(/HTTP Error ([0-9]{3})/i);' +
                    'if(isError && isError.length > 1 && parseInt(isError[1]) > 399) {' +
                    '  messageData.push({action: \'errorStatus\', msg: isError[1]});' +
                    '}';
                String a = await widget.controller.evaluateJavascript(source: toexecute);
                print("A" + a.toString());
                String toexecute3 =
                    "(function(){var lMessData = window.messageData && window.messageData.length ? window.messageData.splice(0, window.messageData.length) : \'\';return lMessData ? JSON.stringify(lMessData) : \'\';})()";
                String c = await widget.controller.evaluateJavascript(source: toexecute3);
                print(c);
                String joker = 'if (IE.fModule) {' +
                    '  if (GApplication.initApp) {' +
                    '    GApplication.initApp({' +
                    '      estAppliMobile : true,' +
                    '      avecExitApp : true,' +
                    '      login : \'' +
                    "mbequet".replaceAll("'", "\\'") +
                    '\',' +
                    '      mdp : \'' +
                    "A16D8E2CD73DA925E638F96C46C729833CBA0210E2AE6194F6882C4178E152C1A7B8A0E6F401D038B48A24266C934E29" +
                    '\',' +
                    '      uuid : \'' +
                    randomUUID +
                    '\',' +
                    '    })' +
                    '  }' +
                    '} else {' +
                    '  Invocateur.abonner(Invocateur.events.modificationPresenceUtilisateur, function(aPresence){' +
                    '    if (!aPresence) {' +
                    '      Invocateur.evenement (Invocateur.events.modificationPresenceUtilisateur, true);' +
                    '    }' +
                    '  }, null);' +
                    '  GApplication.estAppliMobile = true;' +
                    '  GApplication.infoAppliMobile = {' +
                    '    avecExitApp:true' +
                    '  };' +
                    '  if(GApplication.smartAppBanner) \$(\'#\'+GApplication.smartAppBanner.id.escapeJQ()).remove();' +
                    '  GInterface.traiterEvenementValidation(\'' +
                    "mbequet".replaceAll("'", "\\'") +
                    '\', \'' +
                    "A16D8E2CD73DA925E638F96C46C729833CBA0210E2AE6194F6882C4178E152C1A7B8A0E6F401D038B48A24266C934E29" +
                    '\', null, \'' +
                    randomUUID +
                    '\');' +
                    '}';
                String amiajoketou = await widget.controller.evaluateJavascript(source: joker);
                print(amiajoketou);
              });
*/
              await stepper();
              /*var uuid = Uuid();
              String validationProcess = (loginStatus == null || loginStatus["jeton"] == null)
                  ? "(function(){window.hookAccesDepuisAppli = function(){this.passerEnModeValidationAppliMobile('" +
                      (loginStatus != null ? loginStatus["login"].replaceAll("'", "\\'") : "") +
                      '\', \'' +
                      "8798213546" +
                      "')};return \'\';})()"
                  : "(function(){window.hookAccesDepuisAppli = function(){this.passerEnModeValidationAppliMobile('" +
                      (loginStatus != null ? loginStatus["login"].replaceAll("'", "\\'") : "") +
                      '\', \'' +
                      "8798213546" +
                      '\', \'' +
                      loginStatus["jeton"] +
                      '\', \'' +
                      loginStatus["codeJeton"] +
                      "')};return \'\';})()";
              print(validationProcess);
              await controller.evaluateJavascript(source: validationProcess);
              //Injected to get the server metas
              String locationProcess = "(function(){return JSON.stringify(location);})();";

              //Injected after successful login to get the credentials and... useful stuff I guess
              String loginDataProcess =
                  "(function(){return window && window.loginState ? JSON.stringify(window.loginState) : \'\';})();";
              //String test = "(function(){return document.body.innerText;})()";

              await controller.evaluateJavascript(source: loginDataProcess);
              String locationProcessResult = await controller.evaluateJavascript(source: locationProcess);
              //Interprete location to get URLs and other useful stuff
              interpreteLocation(locationProcessResult);
              //Execute a little bit later
              //Get credentials and login stuff
              Timer(new Duration(milliseconds: 250), () async {
                String loginDataProcessResult = await controller.evaluateJavascript(source: loginDataProcess);
                getCreds(loginDataProcessResult);
                interpreteLogin(loginDataProcessResult);
              });*/
            },
            onProgressChanged: (InAppWebViewController controller, int progress) {},
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildText(loginStatus != null ? loginStatus["mdp"] : ""),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _buildFloatingButton(context),
          )
        ],
      ),
    );
  }

  ///called on load stop
  stepper() async {
    switch (step) {
      //Get url metas
      case 1:
        {
          await getMetas();
        }
        break;
      //It should let the user chose its space...
      case 2:
        {
          await selectProfile();
        }
        break;
      case 3:
        {
          await setCookie();
        }
        break;
      case 4:
        {
          await authAndValidateProfile();
        }
        break;
      case 5:
        {
          await loginTest();
        }
    }
  }

  getMetas() async {
    print("Getting metas");
    //Injected function to get metas
    String metaGetFunction = "(function(){return document.body.innerText;})()";
    String metaGetResult = await widget.controller.evaluateJavascript(source: metaGetFunction);
    if (metaGetResult != null && metaGetResult.length > 0) {
      loginData = json.decode(metaGetResult);
      setState(() {
        step = 2;
      });
      stepper();
    } else {
      print("Failed to get metas");
    }
  }

  selectProfile() async {
    print("Selecting profile");

    //lets hardcode the profile
    currentProfile = Map();

    ///TO DO NOT HARCODE
    currentProfile["serverUrl"] = widget.url;
    currentProfile["espaceUrl"] = loginData["espaces"][5]["URL"];
    currentProfile["nomEsp"] = loginData["espaces"][5]["nom"];
    currentProfile["nomEtab"] = loginData["nomEtab"];
    currentProfile["estCAS"] = loginData["CAS"]["actif"];
    currentProfile["casURL"] = loginData["CAS"]["casURL"];
    currentProfile["login"] = "";
    currentProfile["jeton"] = "";

    setState(() {
      step = 3;
    });
    stepper();
  }

  String randomUUID = "121567895313231";
  setCookie() async {
    print("Setting cookie");

    //set cookie
    String cookieFunction = '(function(){try{' +
        'var lJetonCas = "", lJson = JSON.parse(document.body.innerText);' +
        'lJetonCas = !!lJson && !!lJson.CAS && lJson.CAS.jetonCAS;' +
        'document.cookie = "appliMobile=;expires=" + new Date(0).toUTCString();' +
        'if(!!lJetonCas) {' +
        'document.cookie = "validationAppliMobile="+lJetonCas+";expires=" + new Date(new Date().getTime() + (5*60*1000)).toUTCString();' +
        'document.cookie = "uuidAppliMobile=' +
        randomUUID +
        ';expires=" + new Date(new Date().getTime() + (5*60*1000)).toUTCString();' +
        'document.cookie = "ielang=' +
        "1036" +
        ';expires=" + new Date(new Date().getTime() + (365*24*60*60*1000)).toUTCString();' +
        'return "ok";' +
        '} else return "ko";' +
        '} catch(e){return "ko";}})();';
    String cookieFunctionResult = await widget.controller.evaluateJavascript(source: cookieFunction);
    if (cookieFunctionResult == "ok") {
      if (currentProfile["serverUrl"][currentProfile["serverUrl"].length - 1] != '/') {
        currentProfile["serverUrl"] += '/';
      }
      String authFunction = 'location.assign("' + currentProfile["serverUrl"] + currentProfile["espaceUrl"] + '?fd=1")';
      setState(() {
        step = 4;
      });
      String authFunctionResult = await widget.controller.evaluateJavascript(source: authFunction);

      stepper();
    }
  }

  authAndValidateProfile() async {
    print("Validating profile");
    //navigate to address

    Timer(new Duration(milliseconds: 1500), () async {
      String loginDataProcess =
          "(function(){return window && window.loginState ? JSON.stringify(window.loginState) : \'\';})();";
      String loginDataProcessResult = await widget.controller.evaluateJavascript(source: loginDataProcess);
      getCreds(loginDataProcessResult);
      if (loginStatus != null) {
        setState(() {
          step = 5;
        });
        await widget.controller.loadUrl(
            url:
                "https://0782540m.index-education.net/pronote/mobile.eleve.html?fd=1&bydlg=A6ABB224-12DD-4E31-AD3E-8A39A1C2C335");
      }
    });
  }

  loginTest() async {
    print("Login test");
    Timer(new Duration(milliseconds: 1500), () async {
      String toexecute = 'if(!window.messageData) /*window.messageData = [];*/'
          /*'window._finLoadingScriptAppliMobile = function(){' +
          '  messageData.push({action: \'load\'});' +
          '};' */
          /*'if(document.querySelectorAll(\'.conteneur\').length === 1){' +
          '  messageData.push({action: \'errorMsg\', msg: document.querySelectorAll(\'.conteneur\')[0].innerText});' +
          '}' */
          /*'var isError = document.body.textContent.match(/HTTP Error ([0-9]{3})/i);' +
          'if(isError && isError.length > 1 && parseInt(isError[1]) > 399) {' +
          '  messageData.push({action: \'errorStatus\', msg: isError[1]});' +
          '}'*/
          ;
      var a = await widget.controller.evaluateJavascript(source: toexecute);
      /* print("A" + a.toString());
      String toexecute3 =
          "(function(){var lMessData = window.messageData && window.messageData.length ? window.messageData.splice(0, window.messageData.length) : \'\';return lMessData ? JSON.stringify(lMessData) : \'\';})()";
      String c = await widget.controller.evaluateJavascript(source: toexecute3);*/

      String joker = 'if (IE.fModule) {' +
          '  if (GApplication.initApp) {' +
          '    GApplication.initApp({' +
          '      estAppliMobile : true,' +
          '      avecExitApp : true,' +
          '      login : \'' +
          loginStatus["login"].replaceAll("'", "\\'") +
          '\',' +
          '      mdp : \'' +
          loginStatus["mdp"] +
          '\',' +
          '      uuid : \'' +
          randomUUID +
          '\',' +
          '    })' +
          '  }' +
          '} else {' +
          '  Invocateur.abonner(Invocateur.events.modificationPresenceUtilisateur, function(aPresence){' +
          '    if (!aPresence) {' +
          '      Invocateur.evenement (Invocateur.events.modificationPresenceUtilisateur, true);' +
          '    }' +
          '  }, null);' +
          '  GApplication.estAppliMobile = true;' +
          '  GApplication.infoAppliMobile = {' +
          '    avecExitApp:true' +
          '  };' +
          '  if(GApplication.smartAppBanner) \$(\'#\'+GApplication.smartAppBanner.id.escapeJQ()).remove();' +
          '  GInterface.traiterEvenementValidation(\'' +
          loginStatus["login"].replaceAll("'", "\\'") +
          '\', \'' +
          loginStatus["mdp"] +
          '\', null, \'' +
          randomUUID +
          '\');' +
          '}';
      /*String amiajoketou = await widget.controller.evaluateJavascript(source: joker);
      print(amiajoketou);*/
    });
  }

  _validateUrl() {}
  getCreds(String credsData) {
    if (credsData != null && credsData.length > 0) {
      printWrapped(credsData);
      Map temp = json.decode(credsData);
      print(temp["status"]);
      if (temp != null && temp["status"] == 0) {
        loginStatus = temp;
        print(loginStatus);
      } else {}
    } else {
      print("NULL");
    }
  }

  getCookie() {}

  //I have to get an address like that
  //https://0782540m.index-education.net/pronote/InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4

}
