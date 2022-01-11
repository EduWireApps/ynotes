import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/NEW/dialogs/dialogs.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

/// A button that opens a dialog containing the legal links
class LegalLinksButton extends StatelessWidget {
  const LegalLinksButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YButton(
        text: "Mentions légales",
        block: true,
        onPressed: () async {
          await AppDialogs.showLegalLinks(context);
        },
        variant: YButtonVariant.text,
        invertColors: true,
        color: YColor.secondary);
  }
}
