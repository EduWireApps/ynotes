import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/NEW/navigation/app.dart';
import 'package:ynotes/ui/screens/home/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ZApp(
        page: YPage(
            appBar: const YAppBar(title: "Accueil"),
            onRefresh: () async => await Future.wait([appSys.gradesController.refresh(force: true)]),
            body: Column(mainAxisSize: MainAxisSize.max, children: const [CountDown(), Grades()])));
  }
}
