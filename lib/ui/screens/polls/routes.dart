import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/logic/app_config/models.dart';
import 'package:ynotes/ui/screens/polls/polls_tmp.dart';
import 'package:ynotes/ui/screens/polls/sub_pages/details.dart';

final List<CustomRoute> pollsRoutes = [
  CustomRoute(
      path: "/polls",
      icon: MdiIcons.poll,
      title: "Sondages",
      page: const PollsPage(),
      relatedApi: 1,
      tab: appTabs.polls),
  CustomRoute(path: "/polls/details", title: "Sondages", page: const PollsDetailsPage(), relatedApi: 1, show: false),
];
