import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ynotes/land.dart';
import 'package:ynotes/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/UI/gradesPage.dart';

Color myColor = Color(0xff00bfa5);

class LoginPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  Future<String> connectionData;
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _isFirstUse = true;
  String _obligationText = "";

  @override
  initState() {
    tryToConnect();
    getFirstUse();
  }

  getFirstUse() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstUse = prefs.getBool('firstUse') ?? true;
  }

  tryToConnect() async {
    String u = await storage.read(key: "username");
    String p = await storage.read(key: "password");
    if (u != null && p != null) {
      connectionData = connectionStatus(u, p);
      openLoadingDialog();
    }
  }

  openAlertBox() {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: SingleChildScrollView(
              child: Container(
                width: screenSize.size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Conditions d’utilisation",
                          style: TextStyle(fontSize: 24.0, fontFamily: "Asap"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10, bottom: 10),
                        child: SingleChildScrollView(
                            child: Container(
                          child: Text(
                            "En utilisant cette application ainsi que les services tiers vous acceptez et comprenez les conditions suivantes :\n- Mon identifiant ainsi que mon mot de passe ne sont pas enregistrés sur des serveurs, seulement sur votre appareil. Mais vous vous portez responsables en cas de perte de ces derniers.\n - YNote ne se porte pas responsable en cas de suppression ou altération de la qualité de votre compte EcoleDirecte par une entité externe.\n - YNote est un client libre et gratuit et non officiel\n - YNote n’est en aucun cas affilié ou relié à une quelconque entité\n - EcoleDirecte est un produit de la société STATIM",
                            style: TextStyle(
                              fontFamily: "Asap",
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ))),
                    RaisedButton(
                      padding: EdgeInsets.only(
                          left: 60, right: 60, top: 15, bottom: 18),
                      color: Color(0xff27AE60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacement(router(carousel()));
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
          );
        });
  }

  openLoadingDialog() {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: SingleChildScrollView(
              child: Container(
                padding:
                    EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 20),
                child: Column(
                  children: <Widget>[
                    FutureBuilder(
                      future: connectionData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pop(context);
                            if (_isFirstUse == true) {
                              openAlertBox();
                            } else {
                              Navigator.of(context)
                                  .pushReplacement(router(homePage()));
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
                                snapshot.data,
                                textAlign: TextAlign.center,
                              )
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Column(
                            children: <Widget>[
                              Icon(
                                Icons.error,
                                size: MediaQuery.of(context).size.width / 5,
                                color: Colors.redAccent,
                              ),
                              Text(
                                snapshot.error.toString(),
                                textAlign: TextAlign.center,
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

  Widget build(BuildContext context) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);

//BEGINNING OF THE STYLE OF THE WINDOW
    return SafeArea(
        child: Container(
            height: screenSize.size.height -
                screenSize.padding.top -
                screenSize.padding.bottom,
            decoration: BoxDecoration(color: Color(0xFF252B62)),
            child: SingleChildScrollView(
              child: Container(
                  height: screenSize.size.height -
                      screenSize.padding.top -
                      screenSize.padding.bottom,
                  width: screenSize.size.width,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40),
                          Container(
                            child: Text(
                              "Trouvez votre espace",
                              style: TextStyle(
                                  fontFamily: 'Asap',
                                  fontSize: 48,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: screenSize.size.width,
                            margin: EdgeInsets.only(
                                left: screenSize.size.width / 11,
                                top: screenSize.size.height / 28 + 20,
                                bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Nom d'utilisateur",
                                  style: TextStyle(
                                      fontFamily: 'Asap', color: Colors.white),
                                  textAlign: TextAlign.left,
                                ),
                                Text(_obligationText,
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: screenSize.size.width / 12,
                                right: screenSize.size.width / 12),
                            height: 45,
                            child: TextFormField(
                              controller: _username,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(18),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0,
                                      color: Colors.lightBlue.shade50),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0,
                                      color: Colors.lightBlue.shade50),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: screenSize.size.width,
                            margin: EdgeInsets.only(
                                left: screenSize.size.width / 11,
                                top: 20,
                                bottom: 5),
                            child: Text(
                              "Mot de passe",
                              style: TextStyle(
                                  fontFamily: 'Asap', color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            height: 45,
                            margin: EdgeInsets.only(
                                left: screenSize.size.width / 12,
                                right: screenSize.size.width / 12),
                            child: TextFormField(
                              controller: _password,
                              autocorrect: false,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(18),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0,
                                      color: Colors.lightBlue.shade50),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0,
                                      color: Colors.lightBlue.shade50),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin:  EdgeInsets.only(top: 20),
                              child: RaisedButton(
                                padding: EdgeInsets.only(
                                    left: 60, right: 60, top: 15, bottom: 15),
                                color: Color(0xff5DADE2),
                                shape: StadiumBorder(),
                                onPressed: () {
                                  //Actions when pressing the ok button
                                  if (_username.text != "") {
                                    connectionData = connectionStatus(
                                        _username.text, _password.text);
                                    openLoadingDialog();
                                  } else {
                                    _obligationText = " (obligatoire)";
                                    setState(() {});
                                  }
                                },
                                child: Text(
                                  "Se connecter",
                                  style: TextStyle(fontSize: 24),
                                ),
                              )),
                          SizedBox(height: screenSize.size.height / 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Tooltip(
                                message: "EcoleDirecte",
                                preferBelow: false,
                                child: Container(
                                    height: 37,
                                    width: 37,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 4,
                                            color: const Color(0xFFFFFFFF))),
                                    child: SvgPicture.asset(
                                        "assets/images/logoED.svg",
                                        height: 37,
                                        width: 37,
                                        color: Colors.lightBlueAccent)),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: screenSize.size.width / 30),
                                  height: 41,
                                  width: 41,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image(
                                    image: AssetImage('assets/images/space/4.0x/space.png'),
                                    fit: BoxFit.fill,
                                  )),
                            ],
                          )
                        ],
                      ),
                      Container(
                        child: Planet(),
                      )
                    ],
                  )),
            )));
  }
}

//Planet widget
class Planet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return Stack(children: <Widget>[
      Positioned.fill(
        left: 70,
        top: (screenSize.size.height) / 1.6,
        child: Stack(children: <Widget>[
          Container(
            transform:
                Matrix4.translationValues(screenSize.size.width / 1.8, 150, 0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(800.0)),
              color: Color(0xffE1BAA3),
              child: Container(
                width: 326,
                height: 318,
              ),
            ),
          ),
          Container(
            transform:
                Matrix4.translationValues(screenSize.size.width / 1.7, 270, 0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(500.0)),
              color: Color(0xffEBCDBC),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 8.0, color: const Color(0xFFC5A492)),
                  borderRadius: BorderRadius.all(Radius.circular(500.0)),
                ),
                width: 74,
                height: 71,
              ),
            ),
          ),
          Container(
            transform:
                Matrix4.translationValues(screenSize.size.width / 1.45, 170, 0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(500.0)),
              color: Color(0xffEBCDBC),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 8.0, color: const Color(0xFFC5A492)),
                  borderRadius: BorderRadius.all(Radius.circular(500.0)),
                ),
                width: 74,
                height: 71,
              ),
            ),
          ),
        ]),
      )
    ]);
  }
}

Route router(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1, 0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
