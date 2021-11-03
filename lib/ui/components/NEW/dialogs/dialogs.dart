import 'package:flutter/material.dart' hide AboutDialog;
import 'package:ynotes/ui/components/NEW/dialogs/about_dialog.dart';
import 'package:ynotes/ui/components/NEW/dialogs/legal_links_dialog.dart';

/// A class that handles shared dialogs accross the app
class AppDialogs {
  /// A class that handles shared dialogs accross the app
  const AppDialogs._();

  /// Shows a dialog containing legal links.
  static Future<void> showLegalLinks(BuildContext context) async {
    await showDialog(context: context, builder: (_) => const LegalLinksDialog());
  }

  /// Show a dialog that handles legal stuff
  static Future<void> showAboutDialog(BuildContext context) async {
    await showDialog(context: context, builder: (_) => const AboutDialog());
  }
}
