import 'package:flutter/material.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

class SettingsDonorsPage extends StatelessWidget {
  const SettingsDonorsPage({Key? key}) : super(key: key);

  static const List<String> donors = ["MaitreRouge", "AlexTheKing", "Gabriel", "Nino Galea"];

  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "Donateurs"),
        body: Column(
          children: donors
              .map((donor) => ListTile(
                  leading: Icon(Icons.person_rounded, color: theme.colors.foregroundLightColor),
                  title: Text(donor, style: theme.texts.body1)))
              .toList(),
        ));
  }
}
