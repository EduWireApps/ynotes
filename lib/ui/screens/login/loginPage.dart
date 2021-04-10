import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/pronote/schoolsModel.dart';
import 'package:ynotes/core/utils/fileUtils.dart';

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/services/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/ui/animations/FadeAnimation.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/screens/login/loginPageWidgets/loginWebView.dart';
import 'package:ynotes/ui/screens/login/loginPageWidgets/pronoteSetup.dart';
import 'package:ynotes/ui/screens/login/loginPageWidgets/textField.dart';
import 'package:ynotes/ui/screens/school_api_choice/schoolAPIChoicePage.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/core/apis/EcoleDirecte.dart';
import 'package:ynotes/usefulMethods.dart';

Color textButtonColor = Color(0xff252B62);

class LoginSlider extends StatefulWidget {
  final bool setupNeeded;

  const LoginSlider({Key key, this.setupNeeded}) : super(key: key);
  @override
  _LoginSliderState createState() => _LoginSliderState();
}

class _LoginSliderState extends State<LoginSlider> with TickerProviderStateMixin {
  PageController sliderController;
  Map loginHelpTexts = {
    "pronoteSetupText":
        """Nous avons besoin de savoir quel est votre établissement avant que vous puissiez rentrer vos identifiants.""",
    "pronoteUrlSetupText": """Entrez ou vérifiez l'adresse URL Pronote communiquée par votre établissement."""
  };
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _url = TextEditingController();

  AnimationController iconSlideAnimationController;
  Animation<double> iconSlideAnimation;
  PronoteSpace chosenSpace;
  int currentPage;
  initState() {
    super.initState();

    sliderController = PageController(initialPage: widget.setupNeeded ? 0 : 2);
    currentPage = widget.setupNeeded ? 0 : 2;
    sliderController.addListener(_pageViewPageCange);
    iconSlideAnimationController = AnimationController(vsync: this, value: 1, duration: Duration(milliseconds: 500));
    iconSlideAnimation = CurvedAnimation(
      parent: iconSlideAnimationController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
    iconSlideAnimationController.reverse();
  }

  _pageViewPageCange() {
    setState(() {
      currentPage = sliderController.page.round();
    });
  }

  _setupPartCallback(String id) async {
    switch (id) {
      case "qrcode":
        {
          sliderController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }
        break;
      case "location":
        {
          var r = await CustomDialogs.showPronoteSchoolGeolocationDialog(context);
          if (r != null) {
            chosenSpace = r;
            _url.text = chosenSpace.url;
          }
          sliderController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }
        break;
      case "manual":
        {
          sliderController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }
        break;
    }
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

  _getStepText(int page) {
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

  _buildStartingAnimation() {
    MediaQueryData screenSize = MediaQuery.of(context);
    return AnimatedBuilder(
        animation: iconSlideAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + 0.2 * iconSlideAnimation.value,
            child: Transform.translate(
              //animation goes from 1 to 0
              offset: Offset(0, 0 + iconSlideAnimation.value * screenSize.size.height / 10 * 0.2),
              child: Container(
                  width: screenSize.size.width / 5 * 2.2,
                  height: screenSize.size.width / 5 * 2.2,
                  decoration: BoxDecoration(color: Colors.white)),
            ),
          );
        });
  }

  _buildRoundedContainer(Widget child) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
        padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.2),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0))),
        child: child);
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
              textColor: Colors.black),
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

  _buildPageView(bool setupNeeded) {
    InAppWebViewController _controller;

    return PageView(
      physics: new NeverScrollableScrollPhysics(),
      controller: sliderController,
      children: [
        if (setupNeeded) PronoteSetupPart(callback: _setupPartCallback),
        if (setupNeeded)
          PronoteUrlFieldPart(
              pronoteUrl: _url,
              backButton: () {
                sliderController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              },
              onLongPressCallback: () {
                if (appSys.settings["system"]["chosenParser"] == 1 &&
                    _url.text.length == 0 &&
                    _password.text.length == 0 &&
                    _username.text.length == 0) {
                  connectionData = appSys.api.login("demonstration", "pronotevs",
                      url: "https://demo.index-education.net/pronote/eleve.html", mobileCasLogin: false);
                }
                openLoadingDialog();
              },
              loginCallback: () async {
                try {
                  if (await checkPronoteURL(_url.text)) {
                    if (await testIfPronoteCas(_url.text)) {
                      var a = await Navigator.of(context)
                          .push(router(LoginWebView(url: _url.text, controller: _controller)));
                      if (a != null) {
                        connectionData = appSys.api.login(a["login"], a["mdp"], url: _url.text, mobileCasLogin: true);
                        openLoadingDialog();
                      }
                    } else {
                      sliderController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
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

  _buildLoginPart() {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoginPageTextField(_username, "Nom d'utilisateur", false, MdiIcons.account, false),
        SizedBox(
          height: screenSize.size.height / 10 * 0.1,
        ),
        LoginPageTextField(_password, "Mot de passe", true, MdiIcons.key, true),
        SizedBox(height: screenSize.size.height / 10 * 0.4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.setupNeeded)
              CustomButtons.materialButton(context, null, screenSize.size.height / 10 * 0.5, () {
                sliderController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              }, backgroundColor: Colors.grey, label: "Retour", textColor: Colors.white),
            CustomButtons.materialButton(context, null, screenSize.size.height / 10 * 0.5, () async {
              //Actions when pressing the ok button
              if (_username.text != "" &&
                  (appSys.settings["system"]["chosenParser"] == 1 ? _url.text != null : true) &&
                  _password.text != null) {
                //Login using the chosen API
                connectionData = appSys.api
                    .login(_username.text.trim(), _password.text.trim(), url: _url.text.trim(), mobileCasLogin: false);

                openLoadingDialog();
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

    return Container(
      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
      padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.4),
      width: screenSize.size.width,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
                child: new Text(
                  'Foire aux questions',
                  style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: Colors.white60),
                ),
                onTap: () => launch('https://ynotes.fr/faq')),
            SizedBox(
              width: screenSize.size.width / 5 * 0.2,
            ),
            InkWell(
                child: new Text(
                  'PDC',
                  style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: Colors.white60),
                ),
                onTap: () => launch('https://ynotes.fr/legal/PDCYNotes.pdf')),
            SizedBox(
              width: screenSize.size.width / 5 * 0.2,
            ),
            InkWell(
                child: new Text(
                  'CGU',
                  style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: Colors.white60),
                ),
                onTap: () => launch('https://ynotes.fr/legal/CGUYNotes.pdf')),
          ],
        ),
      ),
    );
  }

  Future<List> connectionData;
  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  openAlertBox() {
    var offset = 0.0;

    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertBoxWidget(screenSize: screenSize);
        });
  }

  openLoadingDialog() {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 20),
                child: Column(
                  children: <Widget>[
                    FutureBuilder(
                      future: connectionData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data[0] == 1) {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pop(context);

                            openAlertBox();
                          });
                          return Column(
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                size: MediaQuery.of(context).size.width / 5,
                                color: Colors.lightGreen,
                              ),
                              Text(
                                snapshot.data[1].toString(),
                                textAlign: TextAlign.center,
                              )
                            ],
                          );
                        } else if (snapshot.hasData && snapshot.data[0] == 0) {
                          print(snapshot.data);
                          return Column(
                            children: <Widget>[
                              Icon(
                                Icons.error,
                                size: MediaQuery.of(context).size.width / 5,
                                color: Colors.redAccent,
                              ),
                              Text(
                                snapshot.data[1].toString(),
                                textAlign: TextAlign.center,
                              ),
                              if (snapshot.data.length > 2 && snapshot.data[2] != null && snapshot.data[2].length > 0)
                                Container(
                                  margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                                  child: CustomButtons.materialButton(
                                    context,
                                    MediaQuery.of(context).size.width / 5 * 1.5,
                                    null,
                                    () async {
                                      List stepLogger = snapshot.data[2];
                                      try {
                                        //add step logs to clip board
                                        await Clipboard.setData(new ClipboardData(text: stepLogger.join("\n")));
                                        CustomDialogs.showAnyDialog(context, "Logs copiés dans le presse papier.");
                                      } catch (e) {
                                        CustomDialogs.showAnyDialog(
                                            context, "Impossible de copier dans le presse papier !");
                                      }
                                    },
                                    label: "Copier les logs",
                                  ),
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    //build background
    return Container(
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
        ));
  }
}

class LoginPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String casValue = "Aucun";
  Future<List> connectionData;
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _url = TextEditingController();
  final _cas = TextEditingController();
  bool _isFirstUse = true;
  String _obligationText = "";
  StreamSubscription loginconnexion;

  @override
  initState() {
    super.initState();

    tryToConnect();

    getFirstUse();
  }

  getFirstUse() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('firstUse') == true && storage.read(key: 'agreedTermsAndConfiguredApp') == null) {
      _isFirstUse = true;
    }
  }

  tryToConnect() async {
    String u = await ReadStorage("username");
    String p = await ReadStorage("password");
    String url = await ReadStorage("pronoteurl");
    String cas = await ReadStorage("pronotecas");
    String isCas = await ReadStorage("pronotecas");

    String z = await storage.read(key: "agreedTermsAndConfiguredApp");

    if (u != null && p != null && z != null) {
      connectionData = appSys.api.login(u, p, url: url, cas: cas);
      openLoadingDialog();
    }
  }

  openAlertBox() {
    var offset = 0.0;

    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertBoxWidget(screenSize: screenSize);
        });
  }

  openLoadingDialog() {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 20),
                child: Column(
                  children: <Widget>[
                    FutureBuilder(
                      future: connectionData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data[0] == 1) {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pop(context);
                            if (_isFirstUse == true) {
                              openAlertBox();
                            } else {
                              Navigator.of(context).pushReplacement(router(homePage()));
                            }
                          });
                          return Column(
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                size: MediaQuery.of(context).size.width / 5,
                                color: Colors.lightGreen,
                              ),
                              Text(
                                snapshot.data[1].toString(),
                                textAlign: TextAlign.center,
                              )
                            ],
                          );
                        } else if (snapshot.hasData && snapshot.data[0] == 0) {
                          print(snapshot.data);
                          return Column(
                            children: <Widget>[
                              Icon(
                                Icons.error,
                                size: MediaQuery.of(context).size.width / 5,
                                color: Colors.redAccent,
                              ),
                              Text(
                                snapshot.data[1].toString(),
                                textAlign: TextAlign.center,
                              ),
                              if (snapshot.data.length > 2 && snapshot.data[2] != null && snapshot.data[2].length > 0)
                                Container(
                                  margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                                  child: CustomButtons.materialButton(
                                    context,
                                    MediaQuery.of(context).size.width / 5 * 1.5,
                                    null,
                                    () async {
                                      List stepLogger = snapshot.data[2];
                                      try {
                                        //add step logs to clip board
                                        await Clipboard.setData(new ClipboardData(text: stepLogger.join("\n")));
                                        CustomDialogs.showAnyDialog(context, "Logs copiés dans le presse papier.");
                                      } catch (e) {
                                        CustomDialogs.showAnyDialog(
                                            context, "Impossible de copier dans le presse papier !");
                                      }
                                    },
                                    label: "Copier les logs",
                                  ),
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
          );
        });
  }

  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return LoginSlider(
      setupNeeded: appSys.settings["system"]["chosenParser"] == 1,
    );
  }
}

class AlertBoxWidget extends StatefulWidget {
  const AlertBoxWidget({
    Key key,
    @required this.screenSize,
  }) : super(key: key);

  final MediaQueryData screenSize;

  @override
  _AlertBoxWidgetState createState() => _AlertBoxWidgetState();
}

class _AlertBoxWidgetState extends State<AlertBoxWidget> {
  ScrollController scrollViewController = ScrollController();
  var offset = -4000.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollViewController.addListener(() {
      setState(() {
        offset = scrollViewController.offset;
      });
    });
  }

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
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(widget.screenSize.size.width / 5 * 0.1),
                              child: FittedBox(
                                child: Text(
                                  "Conditions d’utilisation",
                                  style: TextStyle(fontSize: 24.0, fontFamily: "Asap"),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
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
                                future: FileAppUtil.loadAsset("assets/TOS_fr.txt"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                  }
                                  return Text(
                                    snapshot.data.toString() ?? "",
                                    style: TextStyle(
                                      fontFamily: "Asap",
                                    ),
                                    textAlign: TextAlign.left,
                                  );
                                }),
                          ))),
                      RaisedButton(
                        padding: EdgeInsets.only(left: 60, right: 60, top: 15, bottom: 18),
                        color: Color(0xff27AE60),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(router(carousel()));
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
}
