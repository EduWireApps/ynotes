import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

/// A dialog that handles legal stuff
class AboutDialog extends StatelessWidget {
  const AboutDialog({Key? key}) : super(key: key);

  /// A dialog that handles legal stuff
  @override
  Widget build(BuildContext context) {
    const String content =
        "Developpé avec amour en France.\nAPI Pronote adaptée à l'aide de l'API pronotepy développée par Bain sous licence MIT.\nJe remercie la participation des bêta testeurs et des développeurs ayant participé au développement de l'application.";
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
