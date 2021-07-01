import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/ecole_directe.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/ui/animations/fade_animation.dart';
import 'package:ynotes/useful_methods.dart';

testIfExistingAccount() async {
  var u = await storage.read(key: "username");
  var p = await storage.read(key: "password");
  if (u != null && p != null) {
    return true;
  } else {
    return false;
  }
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<String>? connectionData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252B62),
      body: FadeAnimation(
        0.2,
        Center(
            child: Image(
          image: AssetImage('assets/images/icons/app/AppIcon.png'),
          width: 110,
        )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tryToConnect();
  }

  tryToConnect() async {
    await Future.delayed(const Duration(milliseconds: 500), () => "1");
    String? u = await readStorage("username");
    String? p = await readStorage("password");
    String? z = await readStorage("agreedTermsAndConfiguredApp");

    CustomLogger.log("LOADING", "${[u, p, z]}");
    if (u != null && p != null && z != null) {
      Navigator.pushReplacementNamed(context, "/summary");
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }
}
