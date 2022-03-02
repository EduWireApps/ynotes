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

  /// Show a dialog related to the support user metadata
  static Future<void> showUserSupportMetaDataDialog(BuildContext context) async {
    await showDialog(context: context, builder: (_) =>  _UserSupportMetadataDialog());
  }
  /// Show a dialog that show a loader while waiting for a future complete.
  static Future<void> showReportLoaderDialog(BuildContext context, {required Future future}) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _ReportLoaderDialog(
              future: future,
            ));
  }

  /// Shows a color picker dialog.
  static Future<YTColor?> showColorPickerDialog(BuildContext context, {YTColor? color}) async {
    return await showDialog(
        context: context,
        builder: (_) => _ColorPickerDialog(
              color: color,
            ));
  }
}
