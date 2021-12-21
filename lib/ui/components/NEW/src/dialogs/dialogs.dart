part of components;

/// A class that handles shared dialogs accross the app
class AppDialogs {
  /// A class that handles shared dialogs accross the app
  const AppDialogs._();

  /// Shows a dialog containing legal links.
  static Future<void> showLegalLinks(BuildContext context) async {
    await showDialog(context: context, builder: (_) => const _LegalLinksDialog());
  }

  /// Show a dialog that handles legal stuff
  static Future<void> showAboutDialog(BuildContext context) async {
    await showDialog(context: context, builder: (_) => const _AboutDialog());
  }

  /// Show a dialog that show a loader while waiting for a future complete.
  static Future<void> showReportLoaderDialog<T>(BuildContext context, {required Future<T> future}) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _ReportLoaderDialog<T>(
              future: future,
            ));
  }
}
