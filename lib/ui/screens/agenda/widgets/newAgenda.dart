import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/agenda/controller.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';

class Agenda2 extends StatefulWidget {
  @override
  _Agenda2State createState() => _Agenda2State();
}

class _Agenda2State extends State<Agenda2> {
  PreloadPageController con = PreloadPageController(initialPage: 365);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AgendaController>.value(
      value: appSys.agendaController,
      child: Consumer<AgendaController>(builder: (context, model, child) {
        return Container(
          child: Column(
            children: [
              Container(
                height: 400,
                child: PageView.builder(
                  itemCount: 731,
                  itemBuilder: (context, index) => PreloadPageView.builder(
                    itemCount: null,
                    itemBuilder: pageBuilder,
                    onPageChanged: (int position) {
                      appSys.agendaController
                          .setDay(CalendarTime(DateTime.now()).startOfDay.add(Duration(days: (position - 365))));

                      print(position);
                    },
                    preloadPagesCount: 3,
                    controller: con,
                  ),
                ),
              ),
              CustomButtons.materialButton(context, null, null, () async {
                con.jumpToPage(365);
                appSys.agendaController.setDay(DateTime.now());
              }, label: "today")
            ],
          ),
        );
      }),
    );
  }

  Widget pageBuilder(context, index) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text((appSys.agendaController.todayLoaded.toString())),
            Text(((appSys.agendaController.today ?? []).length.toString())),
            Text((appSys.agendaController.week[3].toString())),
          ],
        ),
      ),
    );
  }
}
