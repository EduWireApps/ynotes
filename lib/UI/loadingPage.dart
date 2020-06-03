import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/UI/loginPage.dart';
import 'package:ynotes/animations/FadeAnimation.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/usefulMethods.dart';

import '../apiManager.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

API api = APIManager();

class _LoadingPageState extends State<LoadingPage> {
  Future<String> connectionData;
  String u;
  String p;
  @override
  void initState() {
    tryToConnect();
    getDarkModeSetting();
  }

  tryToConnect() async {
    await setChosenParser(0);
    getChosenParser();
    u = await storage.read(key: "username");
    p = await storage.read(key: "password");
    if (u != null && p != null) {
      return api.login(u, p);
    } else {
      Navigator.of(context).pushReplacement(router(login()));
    }
  }

  getDarkModeSetting() async {
    bool toset = await getSetting("nightmode");
    Provider.of<AppStateNotifier>(context, listen: false).updateTheme(toset);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeAnimation(
        0.8,
        Center(
            child: FlareLoading(
          until: () => tryToConnect(),
          name: 'assets/animations/ynotes.flr',
          startAnimation: 'Load',
          loopAnimation: 'Load',
          endAnimation: 'Ended',
          onSuccess: (test) {
            Navigator.of(context).pushReplacement(router(homePage()));
          },
          onError: (__, _) {
            Navigator.of(context).pushReplacement(router(login()));
          },
        )

            /* FutureBuilder(
                future: tryToConnect(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                   return homePage();
                   
                  }
                  if (snapshot.hasError) {
                  return login();
                  } else {
                    print("waiting");
                    return Container(
                      color: Colors.white,
                      height: screenSize.size.height / 10 * 4,
                      width: screenSize.size.width,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: screenSize.size.height / 10 * 3,
                            width: screenSize.size.width,
                            child: FlareActor(
                              "assets/animations/ynotes.flr",
                              animation: "Ended",
                            ),
                          ),
                          FadeAnimation(
                            1.1,
                            CircularProgressIndicator(
                              backgroundColor: Color(0xff444A83),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }) */

            ),
      ),
    );
  }
}
