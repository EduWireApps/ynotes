import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/services.dart';

/// The entry point of the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bacground service must be initialized before the app, it mustn't be put
  // in [SystemService.init].
  await BackgroundService.init();
  await SystemService.init(all: false, essential: true);
  runZoned<Future<void>>(() async {
    runApp(Phoenix(child: const App()));
  });
}
