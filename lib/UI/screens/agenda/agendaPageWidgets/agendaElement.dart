import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/UI/components/modalBottomSheets/agendaEventDetailsBottomSheet.dart';
import 'package:ynotes/UI/components/modalBottomSheets/agendaEventEditBottomSheet.dart';
import 'package:ynotes/UI/screens/agenda/agendaPage.dart';
import 'package:ynotes/UI/screens/agenda/agendaPageWidgets/spaceAgenda.dart';
import 'package:ynotes/apis/EcoleDirecte.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/models/agenda/values.dart';
import 'package:ynotes/notifications.dart';
import 'package:ynotes/usefulMethods.dart';

class AgendaElement extends StatefulWidget {
  AgendaEvent event;
  final double height;
  final double width;
  final double position;
  final Function setStateCallback;
  AgendaElement(this.event, this.height, this.setStateCallback, {this.width = 4.3, this.position = 0});

  @override
  _AgendaElementState createState() => _AgendaElementState();
}

class _AgendaElementState extends State<AgendaElement> {
  Future<void> refreshAgendaFuture() async {
    if (mounted) {
      setState(() {
        spaceAgendaFuture = localApi.getEvents(agendaDate, true);
        agendaFuture = localApi.getEvents(agendaDate, false);
      });
    }
    var realAF = await spaceAgendaFuture;
    var realSAF = await agendaFuture;
  }

  void initState() {
    super.initState();
  }

  getEventName() {
    if (this.widget.event != null && this.widget.event.name != null && this.widget.event.name != "") {
      return "${widget.event.name[0].toUpperCase()}${widget.event.name.substring(1).toLowerCase()}";
    } else if (this.widget.event.name != "") {
      return "${widget.event.lesson.matiere[0].toUpperCase()}${widget.event.lesson.matiere.substring(1).toLowerCase()}";
    } else {
      return "(sans nom)";
    }
  }

  Future<int> _getRelatedColor() async {
    if (this.widget.event != null && this.widget.event.color != null) {
      return this.widget.event.color;
    } else {
      return await getColor(this.widget.event.lesson.codeMatiere);
    }
  }

  bool buttons = false;
  bool isAlarmSet = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Stack(
      children: [
        Container(
          child: FutureBuilder(
              future: _getRelatedColor(),
              initialData: 0,
              builder: (context, snapshot) {
                Color color = Colors.white;
                if (snapshot.data != null) {
                  color = Color(snapshot.data);
                }
                final f = new DateFormat('H:mm');
                return Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(offset: const Offset(3.0, 3.0), blurRadius: 5.0, spreadRadius: 0.1, color: Colors.black.withOpacity(0.1)),
                  ]),
                  margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1, left: screenSize.size.width / 5 * this.widget.position),
                  child: Material(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomLeft: Radius.circular(screenSize.size.height / 10 * (this.widget.height - 0.2) > 0 ? 0 : 5), bottomRight: Radius.circular(screenSize.size.height / 10 * (this.widget.height - 0.2) > 0 ? 0 : 5)),
                    color: color,
                    child: InkWell(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                      onLongPress: () async {
                        var _event = this.widget.event;
                        if (_event.isLesson) {
                          //Getting color before
                          _event.color = await getColor(this.widget.event.lesson.codeMatiere);
                        }
                        var temp = await agendaEventEdit(context, true, defaultDate: this.widget.event.start, customEvent: _event);

                        if (temp != null) {
                          if (temp != "removed") {
                            if (temp != null) {
                              if (temp.recurrenceScheme != null && temp.recurrenceScheme != "0") {
                                await offline.agendaEvents.addAgendaEvent(temp, temp.recurrenceScheme);

                                setState(() {
                                  this.widget.event = temp;
                                });
                              } else {
                                await offline.agendaEvents.addAgendaEvent(temp, await get_week(temp.start));

                                setState(() {
                                  this.widget.event = temp;
                                });
                              }
                              await LocalNotification.scheduleAgendaReminders(temp);
                            }
                          } else {
                            await offline.reminders.removeAll(_event.id);
                            await LocalNotification.cancelNotification(_event.id.hashCode);
                          }
                          await refreshAgendaFuture();
                          widget.setStateCallback();
                        }
                      },
                      onTap: () async {
                        if (this.widget.event.isLesson) {
                          var _event = this.widget.event;
                          _event.color = await getColor(this.widget.event.lesson.codeMatiere);
                          await lessonDetails(context, _event);
                          await refreshAgendaFuture();
                          print("ok");
                        } else {
                          await lessonDetails(context, widget.event);
                          await refreshAgendaFuture();
                          widget.setStateCallback();
                        }
                      },
                      child: Column(
                        children: [
                          if ((screenSize.size.height / 10 * (this.widget.height - 0.2)) > 0)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                color: darken(color),
                              ),
                              height: screenSize.size.height / 10 * 0.2,
                              width: screenSize.size.width / 5 * this.widget.width,
                            ),

                          //real content
                          Container(
                              key: ValueKey<bool>(buttons),
                              width: screenSize.size.width / 5 * this.widget.width,
                              height: (screenSize.size.height / 10 * (this.widget.height - 0.2)) > 0 ? (screenSize.size.height / 10 * (this.widget.height - 0.2)) : screenSize.size.height / 10 * 0.2,
                              child: Stack(
                                children: [
                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 250),
                                    opacity: this.widget.event.canceled ? 0.5 : 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/redGrid.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: screenSize.size.width / 5 * 4.2,
                                      padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.3, vertical: screenSize.size.height / 10 * 0.1),
                                      child: Wrap(
                                        spacing: screenSize.size.width / 5 * 3.2,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            spacing: screenSize.size.width / 5 * 0.1,
                                            children: [
                                              AutoSizeText(
                                                getEventName(),
                                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.left,
                                                minFontSize: 12,
                                              ),
                                              if (this.widget.event.alarm != null && this.widget.event.alarm != alarmType.none) Container(width: screenSize.size.width / 5 * 0.3, child: FittedBox(child: Icon(Icons.notifications_active_outlined))),
                                            ],
                                          ),
                                          if (this.widget.event.isLesson && widget.event.lesson.teachers != null && widget.event.lesson.teachers.length > 0 && widget.event.lesson.teachers[0] != "")
                                            Wrap(children: [
                                              AutoSizeText(
                                                widget.event.lesson.teachers[0],
                                                style: TextStyle(fontFamily: "Asap"),
                                                textAlign: TextAlign.left,
                                                minFontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ]),
                                          Wrap(
                                            spacing: screenSize.size.width / 5 * 0.1,
                                            children: [
                                              AutoSizeText(
                                                f.format(widget.event.start) + " - " + f.format(widget.event.end).toString(),
                                                style: TextStyle(
                                                  fontFamily: "Asap",
                                                  fontWeight: FontWeight.w200,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.left,
                                                minFontSize: 12,
                                              ),
                                              AutoSizeText(
                                                widget.event.location ?? "",
                                                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w800),
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 12,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
