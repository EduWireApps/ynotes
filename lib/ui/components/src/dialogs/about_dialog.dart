part of components;

/// A dialog that handles legal stuff
class _AboutDialog extends StatelessWidget {
  const _AboutDialog({Key? key}) : super(key: key);

  /// A dialog that handles legal stuff
  @override
  Widget build(BuildContext context) {
    const String content =
        "Developpé avec amour en France.\n\nAPI Pronote adaptée de l'API pronotepy développée par Bain sous licence MIT.\n\nNous tenons à remercier les beta-testeurs ainsi que chaque personne ayant participé à cette application.\n\n The devil is in the detail.";
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return YDialogBase(
              title: "yNotes ${snapshot.data!.version} ${snapshot.data!.buildNumber}",
              body: Text(content, style: theme.texts.body1),
              actions: [
                YButton(
                    onPressed: () => Navigator.pushNamed(context, "/settings/licenses"),
                    text: "LICENSES",
                    variant: YButtonVariant.text),
                YButton(onPressed: () => Navigator.pop(context), text: "FERMER")
              ],
            );
          }
          return Container();
        });
  }
}
