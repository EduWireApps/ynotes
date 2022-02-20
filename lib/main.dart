import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/services.dart';
import 'package:ynotes/core/utilities.dart';

const bool _reset = false;

/// The entry point of the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Dev only.
  if (!kReleaseMode && _reset) {
    await KVS.deleteAll();
    final Directory dir = await FileStorage.getAppDirectory();
    dir.deleteSync(recursive: true);
    await KVS.write(key: "fullReset0", value: "true");
    exit(0);
  }
  // Background service must be initialized before the app, it mustn't be put
  // in [SystemService.init].
  await BackgroundService.init();
  await SystemService.init(all: false, essential: true);
  // TODO: check if `runZoned` is needed.
  runZoned<Future<void>>(() async {
    runApp(Phoenix(child: const App()));
  });
}
