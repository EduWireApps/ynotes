part of components;

/// A button that opens a dialog containing the legal links
class _LegalLinksButton extends StatelessWidget {
  const _LegalLinksButton({Key? key}) : super(key: key);

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
