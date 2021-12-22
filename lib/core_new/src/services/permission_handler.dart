library permission_handler_service;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/packages/shared.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

class PermissionHandlerService {
  const PermissionHandlerService._();

  static Future<bool> handle(BuildContext context, {required Permission permission, required String name}) async {
    final res = await _handle(permission, name);
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

  static Future<Response<void>> _handle(Permission permission, String name, {bool first = true}) async {
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
          return _handle(permission, name, first: false);
        } else {
          return Response(
              error:
                  "Vous avez refusé que yNotes ait accès à la permission \"$name\". Pour accéder à cette fonctionnalité, veuillez réessayer et accepter.");
        }
    }
  }
}
