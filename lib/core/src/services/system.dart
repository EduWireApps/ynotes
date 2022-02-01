library system_service;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/utilities.dart';

import 'package:ynotes/core/services.dart';
import 'package:ynotes/packages/shared.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

class SystemServiceStore extends ChangeNotifier {
  SystemServiceStore();

  final int total = 4;
  int current = 0;
  String text = "";
  bool initialized = false;

  void _notify() {
    notifyListeners();
  }
}

class SystemService {
  const SystemService._();

  static final SystemServiceStore store = SystemServiceStore();

  static Future<void> init({bool all = true, bool essential = false, bool loading = false}) async {
    await LogsManager.init();
    if (all) {
      await migrations();
      await SettingsService.init();
      BugReport.init();
      schoolApi = schoolApiManager(SettingsService.settings.global.api);
      await schoolApi.init();
      await NotificationService.init();
    } else {
      if (essential) {
        await migrations();
        await SettingsService.init();
      }
      if (loading) {
        store.current = 1;
        store.text = "Choix du service scolaire...";
        store._notify();
        schoolApi = schoolApiManager(SettingsService.settings.global.api);
        await Future.delayed(const Duration(milliseconds: 200));
        store.current = 2;
        store.text = "Initialisation du service scolaire...";
        store._notify();
        await schoolApi.init();
        store.current = 3;
        store.text = "Intitialisation de l'outil de report de bug...";
        store._notify();
        BugReport.init();
        store.current = 4;
        store.text = "Intitialisation du service de notifications...";
        store._notify();
        await NotificationService.init();
        store.text = "Chargement terminé !";
        store._notify();
      }
    }
  }

  static Future<void> exit(BuildContext context) async {
    await schoolApi.reset(auth: true);
    await LogsManager.reset();
    await SettingsService.reset();
    await KVS.deleteAll();
    await KVS.write(key: "logsReset0", value: "true");
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
    UIU.setSystemUIOverlayStyle();
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
