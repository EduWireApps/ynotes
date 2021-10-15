import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/NEW/dialogs/legal_links_dialog.dart';

/// A class that handles shared dialogs accross the app
class AppDialogs {
  /// A class that handles shared dialogs accross the app
  const AppDialogs._();

  /// Shows a dialog containing legal links.
  static Future<void> showLegalLinks(BuildContext context) async {
    await showDialog(context: context, builder: (_) => const LegalLinksDialog());
  }
}
