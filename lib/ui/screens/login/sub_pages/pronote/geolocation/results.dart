import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/logic/pronote/login/geolocation/geolocation_controller.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/core/utils/routing_utils.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPronoteGeolocationResultsPage extends StatefulWidget {
  const LoginPronoteGeolocationResultsPage({Key? key}) : super(key: key);

  @override
  _LoginPronoteGeolocationResultsPageState createState() => _LoginPronoteGeolocationResultsPageState();
}

class _LoginPronoteGeolocationResultsPageState extends State<LoginPronoteGeolocationResultsPage> {
  PronoteGeolocationController? geolocationController;
  String _schoolName = "";

  List<Widget> get children {
    List<Widget> _els = [];
    final List<PronoteSchool> schools = geolocationController!.filteredSchools(_schoolName);
    final int _length = schools.length;

    for (int i = 0; i < _length + _length - 1; i++) {
      _els.add(i % 2 == 0
          ? _SchoolTile(
              school: schools[i ~/ 2],
              controller: geolocationController!,
            )
          : const YDivider());
    }

    return _els;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      geolocationController!.addListener(() {
        if (geolocationController!.status == GeolocationStatus.error) {
          handleError();
        }
      });
      geolocationController!.locateSchoolsAround();
    });
  }

  Future<void> handleError() async {
    final GeolocationError error = geolocationController!.error!;
    await YDialogs.showInfo(
        context,
        YInfoDialog(
          title: error.title,
          body: Text(error.message, style: theme.texts.body1),
          confirmLabel: "OK",
        ));
    geolocationController!.reset();
  }

  @override
  Widget build(BuildContext context) {
    geolocationController ??= RoutingUtils.getArgs<PronoteGeolocationController>(context);
    return ControllerConsumer<PronoteGeolocationController>(
      controller: geolocationController!,
      builder: (context, controller, child) {
        return YPage(
          scrollable: true,
            appBar: YAppBar(
              title: LoginContent.pronote.geolocation.results.title,
              bottom: controller.status == GeolocationStatus.loading ? const YLinearProgressBar() : null,
            ),
            body: Column(
              children: [
                if (controller.filteredSchools(_schoolName).isNotEmpty)
                  Padding(
                    padding: YPadding.p(YScale.s2),
                    child: YFormField(
                      type: YFormFieldInputType.text,
                      label: LoginContent.pronote.geolocation.results.search,
                      properties: YFormFieldProperties(textInputAction: TextInputAction.search),
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
                      ? Text(
                          controller.status == GeolocationStatus.loading
                              ? LoginContent.pronote.geolocation.results.searching
                              : LoginContent.pronote.geolocation.noResults,
                          style: theme.texts.body1,
                          textAlign: TextAlign.center,
                        )
                      : Column(children: children),
                )
              ],
            ));
      },
    );
  }
}

class _SchoolTile extends StatelessWidget {
  final PronoteSchool school;
  final PronoteGeolocationController controller;
  const _SchoolTile({Key? key, required this.school, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String distance;
    if (school.coordinates!.length > 2) {
      try {
        double val = double.tryParse(school.coordinates![2])! / 1000;
        distance = LoginContent.pronote.geolocation.results.getDistance(val.toStringAsPrecision(2));
      } catch (e) {
        distance = LoginContent.pronote.geolocation.results.noDistance;
      }
    }
    return ListTile(
      leading: Icon(Icons.school_rounded, color: theme.colors.foregroundLightColor),
      title: RichText(
          text: TextSpan(text: "${school.name!} ", style: theme.texts.title, children: [
        TextSpan(text: "(${school.departmentCode})", style: theme.texts.body1),
      ])),
      subtitle: Padding(
        padding: YPadding.pt(YScale.s1),
        child: Text(distance, style: theme.texts.body1),
      ),
      onTap: () async {
        final spaces = await controller.getSchoolSpaces(school);
        if (spaces != null) {
          String? url;
          if (spaces.length > 1) {
            final res = await YDialogs.getConfirmation(
                context,
                YConfirmationDialog<PronoteSchoolSpace>(
                    title: LoginContent.pronote.geolocation.results.chooseSpace,
                    options: spaces
                        .map((space) => YConfirmationDialogOption<PronoteSchoolSpace>(value: space, label: space.name))
                        .toList()));
            if (res != null) {
              url = res.spaceUrl;
            }
          } else {
            url = spaces[0].spaceUrl;
          }
          if (url != null) {
            Navigator.pushNamed(context, "/login/pronote/url", arguments: url);
          }
        }
      },
    );
  }
}
