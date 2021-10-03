// TODO: document

import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/NEW/dialogs/legal_links_dialog.dart';

class AppDialogs {
  const AppDialogs._();

  static Future<void> showLegalLinks(BuildContext context) async {
    await showDialog(context: context, builder: (_) => const LegalLinksDialog());
  }
}
