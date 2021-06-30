import 'package:flutter/services.dart';

class AndroidPlatformChannel {
  static const platform = const MethodChannel('fr.ynotes/funcs');
  static enableDND() async {
    await platform.invokeMethod('enableDND');
  }

  static openAutoStartSettings() async {
    await platform.invokeMethod('openAutostartSettings');
  }
}
