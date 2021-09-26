import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/ui/animations/fade_animation.dart';
import 'package:ynotes/useful_methods.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/components.dart';

testIfExistingAccount() async {
  var u = await KVS.read(key: "username");
  var p = await KVS.read(key: "password");
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
      backgroundColor: theme.colors.backgroundColor,
      body: FadeAnimation(
        0.2,
        Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: const AssetImage('assets/images/icons/app/AppIcon.png'),
              width: 100,
              color: theme.colors.primary.backgroundColor,
            ),
            const YVerticalSpacer(50),
            const SizedBox(width: 200, child: YLinearProgressBar())
          ],
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
    String? u = await KVS.read(key: "username");
    String? p = await KVS.read(key: "password");
    String? z = await KVS.read(key: "agreedTermsAndConfiguredApp");
    CustomLogger.log("LOADING", "${[u, p, z]}");
    Navigator.pushReplacementNamed(context, u != null && p != null && z != null ? "/summary" : "/login");
  }
}
