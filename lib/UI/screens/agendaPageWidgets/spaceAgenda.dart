import 'dart:async';

import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/components/modalBottomSheets/agendaEventEditBottomSheet.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/addEvent.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/agenda.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/agendaGrid.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/buttons.dart';
import 'package:ynotes/utils/themeUtils.dart';
import 'package:ynotes/utils/fileUtils.dart';

import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';

import '../../../usefulMethods.dart';
import '../agendaPage.dart';

class SpaceAgenda extends StatefulWidget {
  @override
  _SpaceAgendaState createState() => _SpaceAgendaState();
}

Future spaceAgendaFuture;

bool extended = false;

class _SpaceAgendaState extends State<SpaceAgenda> {
  @override
  List<FileInfo> listFiles;
  // ignore: must_call_super
  void initState() {
    // TODO: implement initState
    if (agendaDate == null) {
      setState(() {
        agendaDate = CalendarTime().startOfToday;
      });
    }

    getLessons(agendaDate);
  }

  //Force get date
  getLessons(DateTime date) async {
    await refreshAgendaFutures(force: false);
  }

  Future<void> refreshAgendaFutures({bool force = true}) async {
    if (mounted) {
      setState(() {
        spaceAgendaFuture = localApi.getEvents(agendaDate, true, forceReload: false);
        agendaFuture = localApi.getEvents(agendaDate, false, forceReload: force);
      });
    }
    var realAF = await spaceAgendaFuture;
    var realSAF = await agendaFuture;
  }

  _buildFloatingButton(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return FloatingActionButton(
      heroTag: "btn2",
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenSize.size.width / 5 * 0.8,
        height: screenSize.size.width / 5 * 0.8,
        child: Icon(
          Icons.add,
          size: screenSize.size.width / 5 * 0.5,
        ),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff100A30)),
      ),
      onPressed: () async {
        await addEvent(context);
        await refreshAgendaFutures(force: false);
        setState(() {});
        /*AgendaEvent temp = await agendaEventEdit(context, true, defaultDate: agendaDate);
        if (temp != null) {
          if (temp.recurrenceScheme != null && temp.recurrenceScheme != "0") {
            await offline.addAgendaEvent(temp, temp.recurrenceScheme);
            await refreshAgendaFutures(force: false);
          } else {
            await offline.addAgendaEvent(temp, await get_week(temp.start));
            await refreshAgendaFutures(force: false);
          }
        }
        setState(() {});*/
      },
    );
  }

  _buildAgendaButtons(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return AgendaButtons(
      getLessons: getLessons,
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
        height: screenSize.size.height / 10 * 8,
        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15), color: ThemeUtils.spaceColor()),
        width: screenSize.size.width,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
              child: Container(
                width: screenSize.size.width,
                height: screenSize.size.height,
                child: Container(
                  width: screenSize.size.width,
                  height: screenSize.size.height,
                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        _buildAgendaButtons(context),
                        Container(
                          height: screenSize.size.height / 10 * 8,
                          child: Stack(
                            children: [
                              FutureBuilder(
                                  future: spaceAgendaFuture,
                                  builder: (context, snapshot) {
                                    List<AgendaEvent> lst = snapshot.data;
                                    if (lst != null) {
                                      lst.removeWhere((element) => element.start.isAfter(element.end));
                                    }
                                    if (snapshot.hasData && snapshot.data != null && lst.length != 0 && lst.where((element) => !element.isLesson).toList().length != 0) {
                                      return RefreshIndicator(
                                          onRefresh: refreshAgendaFutures,
                                          child: AgendaGrid(
                                            snapshot.data,
                                            initState,
                                            afterSchool: true,
                                          ));
                                    }
                                    if (snapshot.data != null && (lst.length == 0 || lst.where((element) => !element.isLesson).toList().length == 0)) {
                                      return Center(
                                        child: FittedBox(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.5),
                                                height: screenSize.size.height / 10 * 1.9,
                                                child: Image(fit: BoxFit.fitWidth, image: AssetImage('assets/images/relax.png')),
                                              ),
                                              Text(
                                                "Journée détente ?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontFamily: "Asap", color: Colors.white, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  //Reload list
                                                  refreshAgendaFutures();
                                                },
                                                child: snapshot.connectionState != ConnectionState.waiting
                                                    ? Text("Recharger", style: TextStyle(fontFamily: "Asap", color: Colors.white, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2))
                                                    : FittedBox(child: SpinKitThreeBounce(color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4)),
                                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0), side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SpinKitFadingFour(
                                        color: Theme.of(context).primaryColorDark,
                                        size: screenSize.size.width / 5 * 1,
                                      );
                                    }
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.1, bottom: screenSize.size.height / 10 * 0.4),
                child: _buildFloatingButton(context),
              ),
            ),
          ],
        ));
  }
}
