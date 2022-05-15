import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/globals.dart';

class HiveLifecycleManager extends StatefulWidget {
  final Widget child;

  const HiveLifecycleManager({Key? key, required this.child}) : super(key: key);

  @override
  _HiveLifecycleManagerState createState() => _HiveLifecycleManagerState();
}

class _HiveLifecycleManagerState extends State<HiveLifecycleManager> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // force a close and start from fresh. Just incase
        // a box wasn't closed on inactive/paused
        HiveBoxProvider.close().then((value) async {
          HiveBoxProvider.init();
          await appSys.initOffline();
          appSys.api = apiManager(appSys.offline);
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        HiveBoxProvider.close();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
}
