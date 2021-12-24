import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core_new/services.dart';

/// The entry point of the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemService.init();
  runZoned<Future<void>>(() async {
    runApp(Phoenix(child: const App()));
  });
}
