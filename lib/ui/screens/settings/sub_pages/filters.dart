import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/src/utilities/change_notifier_consumer.dart';
import 'package:ynotes/ui/components/components.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SettingsFiltersPage extends StatelessWidget {
  static const List<String> donors = [
    "MaitreRouge",
    "AlexTheKing",
    "Gabriel",
    "Nino Galea",
    "Killiane Letellier",
    "Eliott Tombarelle"
  ];

  const SettingsFiltersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "Filtres de matières"),
        floatingButtons: [
          YFloatingButton(
              icon: Icons.add_rounded, onPressed: () async => await AppSheets.showAddSubjectFilterSheet(context))
        ],
        body: ChangeNotifierConsumer<GradesModule>(
            controller: schoolApi.gradesModule,
            builder: (context, module, _) => module.customFilters.isEmpty
                ? Padding(
                    padding: YPadding.p(YScale.s4),
                    child: Text("Tu n'as ajouté aucun filtre pour le moment", style: theme.texts.body1),
                  )
                : ListView.builder(
                    itemCount: module.customFilters.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final SubjectsFilter filter = module.customFilters[index];
                      final List<Subject> subjects = filter.subjects
                          .map((e) => e.entityId)
                          .toSet()
                          .map((e) => filter.subjects.firstWhere((element) => element.entityId == e))
                          .toList();
                      final int subjectsCount = subjects.length;
                      return ListTile(
                        leading: Icon(Icons.sort_rounded, color: theme.colors.foregroundColor),
                        title:
                            Text(filter.name, style: theme.texts.body1.copyWith(color: theme.colors.foregroundColor)),
                        subtitle: Text(
                          "$subjectsCount matière${subjectsCount > 1 ? 's' : ''}",
                          style: theme.texts.body2,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () async {
                          await YModalBottomSheets.show(
                              context: context,
                              child: Padding(
                                padding: YPadding.px(YScale.s4),
                                child: Column(
                                  children: [
                                    Text(filter.name, style: theme.texts.title),
                                    YVerticalSpacer(YScale.s6),
                                    ...subjects
                                        .map((subject) => Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: subject.color.backgroundColor,
                                                borderRadius: YBorderRadius.lg,
                                              ),
                                              margin: YPadding.pb(YScale.s4),
                                              padding: YPadding.p(YScale.s3),
                                              child: Text(subject.name,
                                                  style:
                                                      theme.texts.body1.copyWith(color: subject.color.foregroundColor)),
                                            ))
                                        .toList()
                                  ],
                                ),
                              ));
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            YIconButton(
                                icon: Icons.edit_rounded,
                                onPressed: () async =>
                                    await AppSheets.showEditSubjectFilterSheet(context, filter: filter)),
                            YHorizontalSpacer(YScale.s2),
                            YIconButton(
                                icon: Icons.delete_rounded,
                                onPressed: () async {
                                  final bool res = await YDialogs.getChoice(
                                      context,
                                      YChoiceDialog(
                                          color: YColor.danger,
                                          title: "Attention",
                                          body: Text(
                                              "Êtes-vous sûr de vouloir supprimer ce filtre ? Cette action est irréversible.",
                                              style: theme.texts.body1)));
                                  if (res) {
                                    await schoolApi.gradesModule.removeFilter(filter);
                                  }
                                })
                          ],
                        ),
                      );
                    })));
  }
}
