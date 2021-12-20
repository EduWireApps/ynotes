import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ynotes/app/app.dart';

Future<void> main() async {
  await initApp();
  runZoned<Future<void>>(() async {
    runApp(Phoenix(child: const App()));
  });
}
