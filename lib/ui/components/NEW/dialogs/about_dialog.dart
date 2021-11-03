import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

/// A dialog that handles legal stuff
class AboutDialog extends StatelessWidget {
  const AboutDialog({Key? key}) : super(key: key);

  Color get primary => theme.isDark ? theme.colors.primary.foregroundColor : theme.colors.primary.backgroundColor;

  Color getColor(double opacity) {
    return Color.fromRGBO(primary.red, primary.green, primary.blue, opacity);
  }

  MaterialColor get primarySwatch => MaterialColor(primary.value, {
        50: getColor(.1),
        100: getColor(.2),
        200: getColor(.3),
        300: getColor(.4),
        400: getColor(.5),
        500: getColor(.6),
        600: getColor(.7),
        700: getColor(.8),
        800: getColor(.9),
        900: getColor(1),
      });

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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Theme(
                                  data: ThemeData(
                                      primarySwatch: primarySwatch,
                                      fontFamily: theme.fonts.primary,
                                      brightness: theme.themeData.brightness),
                                  child: LicensePage(
                                      applicationIcon: Image(
                                        image: const AssetImage('assets/appico/foreground.png'),
                                        width: YScale.s12,
                                      ),
                                      applicationName: "yNotes",
                                      applicationVersion: "${snapshot.data!.version} ${snapshot.data!.buildNumber}",
                                      applicationLegalese: content))));
                    },
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
