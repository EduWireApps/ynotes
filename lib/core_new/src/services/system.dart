library system_service;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/utils/bugreport_utils.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/core_new/services.dart';
import 'package:ynotes/packages/shared.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

class SystemService {
  const SystemService._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await backwardCompatibility();
    BugReportUtils.init();
    await SettingsService.init();
    schoolApi = schoolApiManager(SettingsService.settings.global.api);
    await schoolApi.init();
    await BackgroundService.init();
  }

  static Future<void> exit(BuildContext context) async {
    await schoolApi.reset(auth: true);
    await KVS.deleteAll();
    theme.updateCurrentTheme(0);
    LogsManager.deleteLogs();
    await SettingsService.reset();
    Phoenix.rebirth(context);
  }

  static Future<bool> handlePermission(BuildContext context,
      {required Permission permission, required String name, bool request = true}) async {
    final res = await _handlePermission(permission, name, first: request);
    if (res.error != null) {
      await YDialogs.showInfo(
          context,
          YInfoDialog(
            title: "Permission refusée",
            body: Text(res.error!, style: theme.texts.body1),
            confirmLabel: "OK",
          ));
    }
    return res.error == null;
  }

  static Future<Response<void>> _handlePermission(Permission permission, String name, {bool first = true}) async {
    if (!(!kIsWeb && (Platform.isAndroid || Platform.isIOS))) {
      return const Response();
    }
    final PermissionStatus status = await (first ? permission.status : permission.request());
    UIUtils.setSystemUIOverlayStyle();
    switch (status) {
      case PermissionStatus.granted:
        return const Response();
      case PermissionStatus.permanentlyDenied:
        return Response(
            error:
                "Vous avez refusé que yNotes ait accès à la permission \"$name\" de façon permanente. Pour accéder à cette fonctionnalité, veuillez la modifier dans les paramètres de votre téléphone.");
      case PermissionStatus.denied:
      default:
        if (first) {
          return _handlePermission(permission, name, first: false);
        } else {
          return Response(
              error:
                  "Vous avez refusé que yNotes ait accès à la permission \"$name\". Pour accéder à cette fonctionnalité, veuillez réessayer et accepter.");
        }
    }
  }
}
