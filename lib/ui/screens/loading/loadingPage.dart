import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/ui/animations/FadeAnimation.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/core/apis/EcoleDirecte.dart';
import 'package:ynotes/usefulMethods.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<String>? connectionData;
  String? u;
  String? p;
  String? z;
  @override
  void initState() {
    tryToConnect();
  }

  tryToConnect() async {
    await Future.delayed(const Duration(milliseconds: 500), () => "1");
    String u = await ReadStorage("username");
    String p = await ReadStorage("password");
    String url = await ReadStorage("pronoteurl");
    String cas = await ReadStorage("pronotecas");
    bool iscas = (await ReadStorage("ispronotecas") == "true");

    z = await storage.read(key: "agreedTermsAndConfiguredApp");
    if (u != null && p != null && z != null && appSys.settings!["system"]["chosenParser"] != null) {
      Navigator.of(context).pushReplacement(router(homePage()));
    } else {
      Navigator.of(context).pushReplacement(router(login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Color(0xff252B62),
      body: FadeAnimation(
        0.2,
        Center(
            child: Image(
          image: AssetImage('assets/images/LogoYNotes.png'),
          width: screenSize.size.width / 5 * 1,
        )),
      ),
    );
  }
}

testIfExistingAccount() async {
  var u = await storage.read(key: "username");
  var p = await storage.read(key: "password");
  if (u != null && p != null) {
    return true;
  } else {
    return false;
  }
}
