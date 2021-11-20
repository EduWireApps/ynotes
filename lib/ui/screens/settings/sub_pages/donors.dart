import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ynotes/useful_methods.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SettingsDonorsPage extends StatelessWidget {
  static const List<String> donors = ["MaitreRouge", "AlexTheKing", "Gabriel", "Nino Galea"];

  const SettingsDonorsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "Donateurs"),
        body: Column(
          children: [
            Container(
              padding: YPadding.p(YScale.s4),
              child: Text(
                  """Les donateurs nous donnent chaque jour envie de développer des fonctionnalités plus poussées et de rendre l'application plus belle encore. C'est super sympa, et nous les remercions infinement de nous soutenir ♡ \n\nNous ajoutons nous-même leurs noms dans cette liste, si vous venez de faire un don laissez-nous donc le temps de vous remercier !""",
                  style: theme.texts.body1),
            ),
            YButton(
                icon: FontAwesomeIcons.handHoldingUsd,
                onPressed: () {
                  launchURL("https://fr.tipeee.com/jsonlines");
                },
                text: "Je veux soutenir yNotes"),
            YVerticalSpacer(YScale.s10),
            ...donors
                .map((donor) => ListTile(
                    leading: Icon(Icons.person_rounded, color: theme.colors.foregroundLightColor),
                    title: Text(donor, style: theme.texts.body1)))
                .toList()
                .cast<Widget>()
          ],
        ));
  }
}
