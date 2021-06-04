import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/login/loginPage.dart';
import 'package:ynotes/usefulMethods.dart';

int? chosen;
late Animation<double> chosenAnimation1;
late AnimationController chosenAnimation1Controller;
late Animation<double> chosenAnimation2;

late AnimationController chosenAnimation2Controller;

class SchoolAPIChoice extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _SchoolAPIChoiceState();
  }
}

class _SchoolAPIChoiceState extends State<SchoolAPIChoice> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
//Disable any back
    return WillPopScope(
      onWillPop: () async {
        Future.value(false);
        return false;
      },
      child: SafeArea(
        child: Container(
          height: screenSize.size.height,
          width: screenSize.size.width,
          color: Colors.white,
          child: Center(
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Pour commencer...",
                      style: TextStyle(
                          fontFamily: "Asap", fontWeight: FontWeight.w300, fontSize: screenSize.size.height / 10 * 0.4),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Choisissez votre service scolaire :",
                      style: TextStyle(fontFamily: "Asap", fontSize: screenSize.size.height / 10 * 0.25),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: screenSize.size.height / 10 * 0.4,
                    ),
                    AnimatedBuilder(
                      animation: chosenAnimation1,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.scale(
                          scale: chosenAnimation1.value,
                          child: child,
                        );
                      },
                      child: Material(
                        color: Color(0xff2874A6),
                        borderRadius: BorderRadius.circular(25),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              chosenAnimation2Controller.reverse();
                              chosen = 0;
                              chosenAnimation1Controller.forward();
                            });
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            width: screenSize.size.width / 5 * 4.2,
                            height: screenSize.size.height / 10 * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width / 10 * 0.1),
                                  margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 10 * 0.2),
                                  child: Image(
                                      width: MediaQuery.of(context).size.width / 5 * 0.6,
                                      height: MediaQuery.of(context).size.width / 5 * 0.4,
                                      fit: BoxFit.fill,
                                      image: AssetImage('assets/images/EcoleDirecte/EcoleDirecteIcon.png')),
                                ),
                                Container(
                                    width: screenSize.size.width / 5 * 3,
                                    child: FittedBox(
                                        child: Text("Ecole Directe",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Asap",
                                                fontSize: screenSize.size.height / 10 * 0.4,
                                                color: Colors.white)))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenSize.size.height / 10 * 0.2,
                    ),
                    AnimatedBuilder(
                      animation: chosenAnimation2,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.scale(
                          scale: chosenAnimation2.value,
                          child: child,
                        );
                      },
                      child: Material(
                        color: Color(0xff61b872),
                        borderRadius: BorderRadius.circular(25),
                        child: InkWell(
                          onTap: () {
                            //CustomDialogs.showUnimplementedSnackBar(context);
                            setState(() {
                              chosenAnimation1Controller.reverse();
                              chosen = 1;
                              chosenAnimation2Controller.forward();
                            });
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            width: screenSize.size.width / 5 * 4.2,
                            height: screenSize.size.height / 10 * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width / 10 * 0.1),
                                  margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 10 * 0.2),
                                  child: Image(
                                      width: MediaQuery.of(context).size.width / 5 * 0.5,
                                      height: screenSize.size.width / 5 * 0.5,
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage('assets/images/Pronote/PronoteIcon.png')),
                                ),
                                Container(
                                    width: screenSize.size.width / 5 * 3,
                                    child: FittedBox(
                                        child: Text("Pronote",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Asap",
                                                fontSize: screenSize.size.height / 10 * 0.4,
                                                color: Colors.white)))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: screenSize.size.height / 10 * 0.4,
                  right: screenSize.size.width / 5 * 0.1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: chosen != null ? Color(0xff5DADE2) : Color(0xffECECEC),
                      shape: StadiumBorder(),
                    ),
                    onPressed: chosen == null
                        ? null
                        : () async {
                            await setChosenParser(chosen);
                            setState(() {
                              appSys.api = apiManager(appSys.offline);
                            });
                            Navigator.of(context).pushReplacement(router(LoginPage()));
                          },
                    child: Text('Connexion', style: TextStyle(fontSize: screenSize.size.width / 5 * 0.2)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getLocalChosen() async {
    setState(() {
      chosen = appSys.settings!["system"]["chosenParser"];
    });
    if (chosen == 0) {
      chosenAnimation2Controller.reverse();
      chosenAnimation1Controller.forward();
    }
    if (chosen == 1) {
      chosenAnimation1Controller.reverse();
      chosenAnimation2Controller.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    chosenAnimation1Controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    chosenAnimation2Controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    chosenAnimation1 = new Tween(
      begin: 1.0,
      end: 1.1,
    ).animate(new CurvedAnimation(parent: chosenAnimation1Controller, curve: Curves.easeInOutQuint));
    chosenAnimation2 = new Tween(
      begin: 1.0,
      end: 1.1,
    ).animate(new CurvedAnimation(parent: chosenAnimation2Controller, curve: Curves.easeInOutQuint));
    getLocalChosen();
  }
}
