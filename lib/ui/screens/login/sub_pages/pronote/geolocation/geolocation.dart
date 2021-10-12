import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/logic/pronote/login/geolocation/geolocation_controller.dart';
import 'package:ynotes/core/utils/controller.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/url/webview.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPronoteGeolocationPage extends StatefulWidget {
  const LoginPronoteGeolocationPage({Key? key}) : super(key: key);

  @override
  _LoginPronoteGeolocationPageState createState() =>
      _LoginPronoteGeolocationPageState();
}

class _LoginPronoteGeolocationPageState
    extends State<LoginPronoteGeolocationPage> {
  final PronoteGeolocationController controller =
      PronoteGeolocationController();
  String _schoolName = "";

  Widget loadingScreen(BuildContext context) {
    return Padding(
      padding: YPadding.p(YScale.s2),
      child: Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Column(
              children: [
                YVerticalSpacer(YScale.s16),
                Text(
                  "Recherche des établissements à proximité en cours...",
                  style: theme.texts.body1,
                  textAlign: TextAlign.center,
                ),
                YVerticalSpacer(YScale.s6),
                const YLinearProgressBar(),
              ],
            )),
      ),
    );
  }

  List<Widget> get children {
    List<Widget> _els = [];
    final List<PronoteSchool> schools = controller.filteredSchools(_schoolName);
    final int _length = schools.length;

    for (int i = 0; i < _length + _length - 1; i++) {
      _els.add(i % 2 == 0
          ? _SchoolTile(
              school: schools[i ~/ 2],
              controller: controller,
            )
          : const YDivider());
    }

    return _els;
  }

  Widget resultsScreen(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: YPadding.p(YScale.s2),
          child: YFormField(
            type: YFormFieldInputType.text,
            label: "Rechercher un établissement",
            properties:
                YFormFieldProperties(textInputAction: TextInputAction.search),
            onChanged: (String value) {
              setState(() {
                _schoolName = value;
              });
            },
          ),
        ),
        Padding(
          padding: YPadding.pt(YScale.s4),
          child: controller.filteredSchools(_schoolName).isEmpty
              ? Text("Aucun résultat! Réessaie...", style: theme.texts.body1)
              : Column(children: children),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    controller.geolocateSchools();
    controller.addListener(() {
      if (controller.status == GeolocationStatus.error) {
        handleError();
      }
    });
  }

  Future<void> handleError() async {
    final GeolocationError error = controller.error!;
    await YDialogs.showInfo(
        context,
        YInfoDialog(
          title: error.title,
          body: Text(error.message, style: theme.texts.body1),
          confirmLabel: "OK",
        ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return YPage(
      appBar: const YAppBar(title: "Géolocalisation"),
      body: ControllerConsumer<PronoteGeolocationController>(
        controller: controller,
        builder: (context, controller, child) {
          return controller.status == GeolocationStatus.success
              ? resultsScreen(context)
              : loadingScreen(context);
        },
      ),
    );
  }
}

class _SchoolTile extends StatelessWidget {
  final PronoteSchool school;
  final PronoteGeolocationController controller;
  const _SchoolTile({Key? key, required this.school, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String distance;
    if (school.coordinates!.length > 2) {
      try {
        double val = double.tryParse(school.coordinates![2])! / 1000;
        distance = "à " + val.toStringAsPrecision(2) + " kilomètres";
      } catch (e) {
        distance = "(distance non définie)";
      }
    }
    return ListTile(
      leading:
          Icon(Icons.school_rounded, color: theme.colors.foregroundLightColor),
      title: RichText(
          text: TextSpan(
              text: "${school.name!} ",
              style: theme.texts.title,
              children: [
            TextSpan(
                text: "(${school.departmentCode})", style: theme.texts.body1),
          ])),
      subtitle: Padding(
        padding: YPadding.pt(YScale.s1),
        child: Text(distance, style: theme.texts.body1),
      ),
      onTap: () async {
        final dynamic res = await Navigator.pushNamed(
            context, "/login/pronote/url/webview",
            arguments: LoginPronoteUrlWebviewPageArguments(
                "${school.url!}/mobile.eleve.html"));

        if (res != null) {
          final List<dynamic>? data = await appSys.api!
              .login(res["login"], res["mdp"], additionnalSettings: {
            "url": "${school.url!}/mobile.eleve.html",
            "mobileCasLogin": true,
          });
          if (data != null && data[0] == 1) {
            YSnackbars.success(context, title: "Connecté !", message: data[1]);
            await Future.delayed(const Duration(seconds: 3));
            Navigator.pushReplacementNamed(context, "/terms");
          } else {
            YSnackbars.error(context, title: "Erreur", message: data![1]);
          }
        }
      },
    );
  }
}
