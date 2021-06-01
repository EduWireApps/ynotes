import 'package:flutter/services.dart';

class AndroidPlatformChannel {
  static const platform = const MethodChannel('fr.ynotes/funcs');
  static enableDND() async {
    var i = await platform.invokeMethod('enableDND');
  }

  static openAutoStartSettings() async {
    var i = await platform.invokeMethod('openAutostartSettings');
  }
}
