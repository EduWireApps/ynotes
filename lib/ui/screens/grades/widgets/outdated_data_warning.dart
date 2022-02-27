import 'package:flutter/material.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

class OutdatedDataWarning extends StatelessWidget {
  const OutdatedDataWarning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YIconButton(
      icon: Icons.info_rounded,
      onPressed: () async {
        await YDialogs.showInfo(
            context,
            YInfoDialog(
                title: "Données obsolètes",
                confirmLabel: "OK",
                body: Text(
                    "Seule la moyenne générale est calculée en temps réel. Actuellement, les autres données (moyenne de classe, maximum et minimum) sont obsolètes, elles seront mises à jour dès que l'information sera disponible.",
                    style: theme.texts.body1)));
      },
      foregroundColor: theme.colors.warning.backgroundColor,
    );
  }
}
