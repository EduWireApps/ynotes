import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/pronote/schoolsModel.dart';
import 'package:ynotes/core/utils/fileUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/textField.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:ynotes/ui/screens/login/loginPageWidgets/loginWebView.dart';
import 'package:ynotes/ui/screens/login/loginPageWidgets/pronoteSetup.dart';
import 'package:ynotes/ui/screens/login/loginPageWidgets/qrCodeLogin.dart';
import 'package:ynotes/ui/screens/school_api_choice/schoolAPIChoicePage.dart';
import 'package:ynotes/usefulMethods.dart';

Color textButtonColor = Color(0xff252B62);

class AlertBoxWidget extends StatefulWidget {
  final MediaQueryData screenSize;

  const AlertBoxWidget({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  @override
  _AlertBoxWidgetState createState() => _AlertBoxWidgetState();
}

class LoginDialog extends StatefulWidget {
  final Future<List> connectionData;
  const LoginDialog(this.connectionData, {Key? key}) : super(key: key);

  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class LoginSlider extends StatefulWidget {
  final bool? setupNeeded;

  const LoginSlider({Key? key, this.setupNeeded}) : super(key: key);
  @override
  _LoginSliderState createState() => _LoginSliderState();
}

class _AlertBoxWidgetState extends State<AlertBoxWidget> {
  ScrollController scrollViewController = ScrollController();
  var offset = -4000.0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        height: widget.screenSize.size.height / 10 * 6,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: scrollViewController,
                child: Container(
                  width: widget.screenSize.size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Conditions d’utilisation",
                          style: TextStyle(fontSize: 24, fontFamily: "Asap", fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 4.0,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 10),
                          child: SingleChildScrollView(
                              child: Container(
                            child: FutureBuilder(
                                //Read the TOS file
                                future: FileAppUtil.loadAsset("assets/documents/TOS_fr.txt"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                  }
                                  return Text(
                                    snapshot.data.toString(),
                                    style: TextStyle(
                                      fontFamily: "Asap",
                                    ),
                                    textAlign: TextAlign.left,
                                  );
                                }),
                          ))),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(left: 60, right: 60, top: 15, bottom: 18),
                          primary: Color(0xff27AE60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, "/intro");
                        },
                        child: Text(
                          "J'accepte",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible:
                    (offset - (scrollViewController.hasClients ? scrollViewController.position.maxScrollExtent : 0) <
                        -45),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: widget.screenSize.size.height / 10 * 0.1),
                    child: FloatingActionButton(
                      onPressed: () {
                        scrollViewController.animateTo(scrollViewController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                      },
                      child: RotatedBox(quarterTurns: 3, child: Icon(Icons.chevron_left)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollViewController.addListener(() {
      setState(() {
        offset = scrollViewController.offset;
      });
    });
  }
}

class _LoginDialogState extends State<LoginDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 20),
            child: Column(
              children: <Widget>[
                FutureBuilder<List>(
                  future: widget.connectionData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.length > 0 &&
                        snapshot.data![0] == 1) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pop(context);

                        openAlertBox();
                      });
                      return Column(
                        children: <Widget>[
                          Icon(
                            Icons.check_circle,
                            size: 90,
                            color: Colors.lightGreen,
                          ),
                          Text(
                            snapshot.data![1].toString(),
                            textAlign: TextAlign.center,
                          )
                        ],
                      );
                    } else if (snapshot.hasData && snapshot.data![0] == 0) {
                      print(snapshot.data);
                      return Column(
                        children: <Widget>[
                          Icon(
                            Icons.error,
                            size: 90,
                            color: Colors.redAccent,
                          ),
                          Text(
                            snapshot.data![1].toString(),
                            textAlign: TextAlign.center,
                          ),
                          if (snapshot.data!.length > 2 && snapshot.data![2] != null && snapshot.data![2].length > 0)
                            CustomButtons.materialButton(
                              context,
                              120,
                              null,
                              () async {
                                List stepLogger = snapshot.data![2];
                                try {
                                  //add step logs to clip board
                                  await Clipboard.setData(new ClipboardData(text: stepLogger.join("\n")));
                                  CustomDialogs.showAnyDialog(context, "Logs copiés dans le presse papier.");
                                } catch (e) {
                                  CustomDialogs.showAnyDialog(context, "Impossible de copier dans le presse papier !");
                                }
                              },
                              label: "Copier les logs",
                            )
                        ],
                      );
                    } else {
                      return Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            backgroundColor: Color(0xff444A83),
                          ));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  openAlertBox() {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertBoxWidget(screenSize: screenSize);
        });
  }
}

class _LoginSliderState extends State<LoginSlider> with TickerProviderStateMixin, YPageMixin {
  PageController? sliderController;
  Map loginHelpTexts = {
    "pronoteSetupText":
        """Nous avons besoin de savoir quel est votre établissement avant que vous puissiez rentrer vos identifiants.""",
    "pronoteUrlSetupText": """Entrez ou vérifiez l'adresse URL Pronote communiquée par votre établissement."""
  };
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _url = TextEditingController();

  late AnimationController iconSlideAnimationController;
  late Animation<double> iconSlideAnimation;
  late PronoteSpace chosenSpace;
  int? currentPage;
  Future<List>? connectionData;

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    //build background

    return Material(
      child: Container(
          height: screenSize.size.height,
          width: screenSize.size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff22256A),
              Color(0xff5C66C1),
            ],
          )),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              _loginTextAndHelpButton(),
              Container(
                  height: screenSize.size.height / 10 * 4, width: screenSize.size.width, child: _buildPageView(true)),
              Spacer(),
              _buildMetaPart()
            ],
          )),
    );
  }

  formatURL(String url) {
    RegExp regExp = new RegExp(
      r"(https://.*\.index-education.net/pronote)(.*)",
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
        print("A");
        suffix = "/mobile.eleve.html";
        return [0, (regExp.firstMatch(url)?.group(1) ?? "") + suffix];
      }
      //situation where only mobile. is missing
      else if (suffixMatches.firstMatch(suffix)?.group(1) == null &&
          suffixMatches.firstMatch(suffix)?.group(2) != null) {
        print("B");

        suffix = "/mobile." + (suffixMatches.firstMatch(suffix)?.group(2) ?? "");
        return [0, (regExp.firstMatch(url)?.group(1) ?? "") + suffix];
      }

      //situation where everything matches
      else if (suffixMatches.firstMatch(suffix)?.groups([1, 2]).every((element) => element != null) ?? false) {
        print("C");

        suffix = "/" +
            (suffixMatches.firstMatch(suffix)?.group(1) ?? "") +
            (suffixMatches.firstMatch(suffix)?.group(2) ?? "");

        return [1, (regExp.firstMatch(url)?.group(1) ?? "") + suffix];
      }
    } else {
      throw ("Wrong url");
    }
  }

  initState() {
    super.initState();

    sliderController = PageController(initialPage: widget.setupNeeded! ? 0 : 2);
    currentPage = widget.setupNeeded! ? 0 : 2;
    sliderController!.addListener(_pageViewPageCange);
    iconSlideAnimationController = AnimationController(vsync: this, value: 1, duration: Duration(milliseconds: 500));
    iconSlideAnimation = CurvedAnimation(
      parent: iconSlideAnimationController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
    iconSlideAnimationController.reverse();
  }

  openLoadingDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoginDialog(connectionData!);
        });
  }

  _buildLoginPart() {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextField(_username, "Nom d'utilisateur", false, MdiIcons.account, false),
        SizedBox(
          height: screenSize.size.height / 10 * 0.1,
        ),
        CustomTextField(_password, "Mot de passe", true, MdiIcons.key, true),
        SizedBox(height: screenSize.size.height / 10 * 0.4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.setupNeeded!)
              CustomButtons.materialButton(context, null, screenSize.size.height / 10 * 0.5, () {
                sliderController!.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              }, backgroundColor: Colors.grey, label: "Retour", textColor: Colors.white),
            CustomButtons.materialButton(context, null, screenSize.size.height / 10 * 0.5, () async {
              //Actions when pressing the ok button
              if (_username.text != "" && (appSys.settings!["system"]["chosenParser"] == 1 ? _url.text != "" : true)) {
                //Login using the chosen API
                connectionData = appSys.api!.login(_username.text.trim(), _password.text.trim(), additionnalSettings: {
                  "url": _url.text.trim(),
                  "mobileCasLogin": false,
                });
                if (connectionData != null) openLoadingDialog();
              } else {
                CustomDialogs.showAnyDialog(context, "Remplissez tous les champs.");
              }
            }, backgroundColor: Colors.green, label: "Se connecter", textColor: Colors.white),
          ],
        )
      ],
    );
  }

  _buildMetaPart() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 480),
      child: Container(
        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
        padding: EdgeInsets.symmetric(horizontal: 5),
        width: screenSize.size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                  child: new Text(
                    'Foire aux questions',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: Colors.white60, fontSize: 17),
                  ),
                  onTap: () => launch('https://ynotes.fr/faq')),
            ),
            Expanded(
              child: InkWell(
                  child: new Text('PDC',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Asap", fontWeight: FontWeight.bold, color: Colors.white60, fontSize: 17)),
                  onTap: () => launch('https://ynotes.fr/legal/PDCYNotes.pdf')),
            ),
            Expanded(
              child: InkWell(
                  child: new Text(
                    'CGU',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: Colors.white60, fontSize: 17),
                  ),
                  onTap: () => launch('https://ynotes.fr/legal/CGUYNotes.pdf')),
            ),
          ],
        ),
      ),
    );
  }

  _buildPageView(bool setupNeeded) {
    InAppWebViewController? _controller;

    return PageView(
      physics: new NeverScrollableScrollPhysics(),
      controller: sliderController,
      children: [
        if (setupNeeded) PronoteSetupPart(callback: _setupPartCallback),
        if (setupNeeded)
          PronoteUrlFieldPart(
              pronoteUrl: _url,
              backButton: () {
                sliderController!.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              },
              onLongPressCallback: () {
                if (appSys.settings!["system"]["chosenParser"] == 1 &&
                    _url.text.length == 0 &&
                    _password.text.length == 0 &&
                    _username.text.length == 0) {
                  connectionData = appSys.api!.login("demonstration", "pronotevs", additionnalSettings: {
                    "url": "https://demo.index-education.net/pronote/parent.html",
                    "mobileCasLogin": false,
                  });
                }
                if (connectionData != null) openLoadingDialog();
              },
              loginCallback: () async {
                try {
                  if (formatURL(_url.text)[0] == 0) {
                    setState(() {
                      _url.text = formatURL(_url.text)[1];
                    });
                    CustomDialogs.showErrorSnackBar(
                        context,
                        "Nous avons corrigé automatiquement l'adresse URL. Vérifiez puis appuyez à nouveau sur Se connecter",
                        null);

                    return;
                  }
                  if (await checkPronoteURL(_url.text)) {
                    if (await testIfPronoteCas(_url.text)) {
                      var a = await Navigator.of(context)
                          .push(router(LoginWebView(url: _url.text, controller: _controller)));
                      if (a != null) {
                        connectionData = appSys.api!.login(a["login"], a["mdp"], additionnalSettings: {
                          "url": _url.text,
                          "mobileCasLogin": true,
                        });
                        if (connectionData != null) openLoadingDialog();
                      }
                    } else {
                      sliderController!.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                    }
                  } else {
                    CustomDialogs.showErrorSnackBar(context, "Adresse invalide", "(pas de log spécifique)");
                  }
                } catch (e) {
                  print(e);
                  CustomDialogs.showErrorSnackBar(context, "Impossible de se connecter à cette adresse", e.toString());
                }
              }),
        _buildLoginPart(),
      ],
    );
  }

  _buildStepsText() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      height: screenSize.size.height / 10 * 1,
      width: screenSize.size.width,
      padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
      child: Text(_getStepText(currentPage),
          textAlign: TextAlign.center, style: TextStyle(fontFamily: "Asap", color: Colors.white, fontSize: 15)),
    );
  }

  _getStepText(int? page) {
    if (page == 0) {
      return loginHelpTexts["pronoteSetupText"];
    }
    if (page == 1) {
      return loginHelpTexts["pronoteUrlSetupText"];
    }
    if (page == 2) {
      return "Entrez vos identifiants de connexion.";
    }
  }

  _loginTextAndHelpButton() {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      child: Column(
        children: [
          CustomButtons.materialButton(context, null, screenSize.size.height / 10 * 0.5, () async {
            Navigator.of(context).pushReplacement(router(SchoolAPIChoice()));
          },
              label: "Retourner au selecteur d'application",
              backgroundColor: Colors.white,
              icon: Icons.home,
              textColor: Colors.black,
              padding: EdgeInsets.all(10)),
          Text(
            "Se connecter",
            style: TextStyle(fontFamily: 'Asap', color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () async {
              launch('https://support.ynotes.fr/compte');
            },
            child: Text("En savoir plus sur la connexion",
                style: TextStyle(
                  fontFamily: 'Asap',
                  color: Colors.transparent,
                  shadows: [Shadow(color: Colors.white, offset: Offset(0, -5))],
                  fontSize: 17,
                  decorationColor: Colors.white,
                  fontWeight: FontWeight.normal,
                  textBaseline: TextBaseline.alphabetic,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                  decorationStyle: TextDecorationStyle.dashed,
                )),
          ),
          Container(
              width: screenSize.size.height / 10 * 0.1,
              height: screenSize.size.height / 10 * 0.1,
              margin: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5000), color: Colors.white)),
          _buildStepsText(),
        ],
      ),
    );
  }

  _pageViewPageCange() {
    setState(() {
      currentPage = sliderController!.page!.round();
    });
  }

  _setupPartCallback(String id) async {
    switch (id) {
      case "qrcode":
        {
          Navigator.of(context).push(router(YPageLocal(
            child: QRCodeLoginPage(),
            title: "Connexion par QR Code",
            scrollable: false,
          )));
        }
        break;
      case "location":
        {
          var r = await CustomDialogs.showPronoteSchoolGeolocationDialog(context);
          if (r != null) {
            chosenSpace = r;
            _url.text = chosenSpace.url!;
          }
          sliderController!.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }
        break;
      case "manual":
        {
          sliderController!.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }
        break;
    }
  }
}
