import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/NEW/navigation/app.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AgendaEvent? nextLesson;

  // Duration? get time => nextLesson == null ? null : nextLesson!.start!.difference(DateTime.now());
  Duration? get time => nextLesson == null ? null : DateTime(2021, 11, 17, 18, 29).difference(DateTime.now());

  late final Timer _timer;

  String get name => nextLesson?.name ?? 'NOPE';

  String get location => nextLesson?.location ?? 'NOPE';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setTime();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  Future<void> setTime() async {
    final DateTime now = DateTime.now();
    final lessons = await appSys.api!.getEvents(now.add(const Duration(days: 1)), forceReload: true) ?? [];

    final AgendaEvent? nextLesson = lessons.isEmpty
        ? null
        : lessons.reduce((a, b) => a.start!.difference(now).abs() < b.start!.difference(now).abs() ? a : b);
    setState(() {
      this.nextLesson = nextLesson;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZApp(
        page: YPage(
            appBar: const YAppBar(title: "Accueil"),
            body: Column(mainAxisSize: MainAxisSize.max, children: [
              Container(
                  width: double.infinity,
                  padding: YPadding.p(YScale.s4),
                  color: theme.colors.backgroundLightColor,
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                                value: 1.0 - 1.0 * (time?.inSeconds.abs() ?? 0) / 3600,
                                color: theme.colors.primary.backgroundColor),
                          ),
                          Positioned.fill(
                              child: Center(
                            child: Text(
                                "${time?.inMinutes}:${((time?.inSeconds.abs() ?? 0) - ((time?.inMinutes.abs() ?? 0) * 60)).toString().padLeft(2, '0')}",
                                style: theme.texts.body1),
                          ))
                        ],
                      ),
                      YHorizontalSpacer(YScale.s2),
                      Text("$name en $location", style: theme.texts.body1),
                    ],
                  ))
            ])));
  }
}
