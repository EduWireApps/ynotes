import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

/// A dialog containing legal links.
class LegalLinksDialog extends StatelessWidget {
  /// A dialog containing legal links.
  const LegalLinksDialog({Key? key}) : super(key: key);

  static const List<_LegalLink> _legalLinks = [
    _LegalLink(
      text: "Politique de confidentialité",
      url: "https://ynotes.fr/legal/pdc.pdf",
    ),
    _LegalLink(text: "Conditions d'utilisation", url: "https://ynotes.fr/legal/cgu.pdf")
  ];

  @override
  Widget build(BuildContext context) {
    return YDialogBase(
      title: 'Mentions légales',
      body: Column(children: [
        for (final link in _legalLinks)
          YButton(
              text: link.text,
              onPressed: () => launch(link.url),
              block: true,
              color: YColor.secondary,
              invertColors: true,
              variant: YButtonVariant.text),
      ]),
      actions: [YButton(text: "FERMER", onPressed: () => Navigator.pop(context))],
    );
  }
}

class _LegalLink {
  final String text;
  final String url;

  const _LegalLink({required this.text, required this.url});
}
