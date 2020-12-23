import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AndroidPlatformChannel {
  static const platform = const MethodChannel('fr.ynotes/autostart');
  static openAutoStartSettings() async {
    var i = await platform.invokeMethod('openAutostartSettings');
  }
}
