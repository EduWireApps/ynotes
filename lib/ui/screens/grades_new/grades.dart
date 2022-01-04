import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/core_new/api.dart';
import 'package:ynotes/ui/components/NEW/components.dart';
import 'package:ynotes/ui/screens/grades_new/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({Key? key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final GradesModule module = schoolApi.gradesModule;
  bool simulate = false;

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<GradesModule>(
        controller: module,
        builder: (context, module, _) {
          return ZApp(
              page: YPage(
            onRefresh: () => module.fetch(online: true),
            appBar: const YAppBar(title: "Notes", actions: [YBadge(text: "En bêta")]),
            useBottomNavigation: false,
            navigationInitialIndex: module.periods.indexOf(module.currentPeriod!),
            navigationElements: module.periods
                .map((period) => YNavigationElement(label: period.name, widget: PeriodPage(module, period, simulate)))
                .toList(),
            onPageChanged: (int value) {
              module.setCurrentPeriod(module.periods[value]);
            },
            floatingButtons: simulate
                ? [
                    YFloatingButton(icon: Icons.add_rounded, onPressed: () {}),
                    YFloatingButton(
                        icon: Icons.close_rounded,
                        onPressed: () {
                          setState(() {
                            simulate = false;
                          });
                        })
                  ]
                : [
                    YFloatingButton(
                        icon: MdiIcons.flask,
                        onPressed: () {
                          setState(() {
                            simulate = true;
                          });
                        })
                  ],
          ));
        });
  }
}
