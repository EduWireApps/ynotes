import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/ui/components/components.dart';
import 'package:ynotes/ui/screens/grades/routes.dart';
import 'package:ynotes/ui/screens/grades/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({Key? key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final GradesModule module = schoolApi.gradesModule;
  bool simulate = false;
  bool init = false;

  @override
  Widget build(BuildContext context) {
    if (!init) {
      final GradesPageArguments? args = AppRouter.getArgs<GradesPageArguments?>(context);
      if (args != null) {
        module.setCurrentPeriod(args.grade.period.value!);
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            init = true;
          });
          YModalBottomSheets.show(context: context, child: GradeDetailsSheet(args.grade, false));
        });
      }
    }
    return ChangeNotifierConsumer<GradesModule>(
        controller: module,
        builder: (context, module, _) {
          final bool empty = module.grades.isEmpty || module.currentPeriod == null;
          Future<void> refresh() async {
            final res = await module.fetch();
            if (res.error != null) {
              YSnackbars.error(context, message: res.error!);
            }
          }

          final List<int?> ids = module.periods.map((e) => e.id).toList();
          final int? periodId = module.currentPeriod?.id;
          final bool contained = ids.contains(periodId);
          final int id = contained ? ids.indexOf(periodId) : 0;

          return ZApp(
              page: YPage(
            onRefresh: refresh,
            appBar: YAppBar(
              title: "Notes",
              actions: [
                if (simulate) const YBadge(text: "SIMULATEUR"),
                YHorizontalSpacer(YScale.s2),
                const YBadge(text: "BETA", color: YColor.danger),
                if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                  YIconButton(icon: Icons.refresh_rounded, onPressed: refresh),
              ],
              bottom: empty && module.isFetching ? const YLinearProgressBar() : null,
            ),
            useBottomNavigation: false,
            scrollable: !empty,
            navigationInitialIndex: id,
            navigationElements: empty
                ? null
                : module.periods
                    .map((period) =>
                        YNavigationElement(label: period.name, widget: PeriodPage(module, period, simulate)))
                    .toList(),
            body: !empty
                ? null
                : Padding(
                    padding: YPadding.p(YScale.s4),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(AppRouter.routes.where((element) => element.path == "/grades").first.icon,
                              color: theme.colors.foregroundColor, size: YScale.s32),
                          YVerticalSpacer(YScale.s4),
                          Text(
                            "Pas de notes !",
                            style: theme.texts.body1,
                            textAlign: TextAlign.center,
                          ),
                          YVerticalSpacer(YScale.s6),
                          YButton(
                              onPressed: refresh,
                              text: "Rafraîchir".toUpperCase(),
                              color: YColor.secondary,
                              isDisabled: module.isFetching)
                        ],
                      ),
                    ),
                  ),
            onPageChanged: (int value) {
              module.setCurrentPeriod(module.periods[value]);
            },
            floatingButtons: empty
                ? null
                : simulate
                    ? [
                        YFloatingButton(
                            icon: Icons.add_rounded,
                            onPressed: () async {
                              final Grade? grade =
                                  await YModalBottomSheets.show(context: context, child: AddCustomGradeSheet(module));
                              if (grade != null) {
                                await module.addCustomGrade(grade);
                              }
                            }),
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
