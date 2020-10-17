import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/animations/FadeAnimation.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:flutter/src/scheduler/binding.dart';
import 'package:ynotes/UI/components/modalBottomSheets/lessonDetailsBottomSheet.dart';
import 'package:ynotes/UI/components/modalBottomSheets/utils.dart';
import 'package:ynotes/UI/components/space/spaceOverlay.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import '../../../background.dart';
import '../../../usefulMethods.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/apiManager.dart';
import 'package:ynotes/UI/screens/spacePageWidgets/agendaGrid.dart';
import 'dart:async';
import 'package:ynotes/UI/components/expandable_bottom_sheet-master/src/raw_expandable_bottom_sheet.dart';
import 'dart:io';

class AgendaElement extends StatefulWidget {
  final AgendaEvent event;
  final double height;
  final double width;
  final double position;
  const AgendaElement(this.event, this.height, {this.width = 4.3, this.position = 0});

  @override
  _AgendaElementState createState() => _AgendaElementState();
}

class _AgendaElementState extends State<AgendaElement> {
  bool buttons = false;
  bool isAlarmSet = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      child: FutureBuilder(
          future: this.widget.event.isLesson ? getColor(this.widget.event.lesson.codeMatiere) : getEventColor(this.widget.event.id),
          initialData: 0,
          builder: (context, snapshot) {
            Color color = Color(snapshot.data);
            return Container(
              
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(offset: const Offset(3.0, 3.0), blurRadius: 5.0, spreadRadius: 0.1, color: Colors.black.withOpacity(0.1)),
              ]),
              margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1, left: screenSize.size.width / 5 * this.widget.position),
              child: Material(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: color,
                child: InkWell(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                  onLongPress: () {
                    setState(() {
                      buttons = !buttons;
                    });
                  },
                  onTap: () {
                    if (this.widget.event.isLesson) {
                      lessonDetails(context, widget.event.lesson, color);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                          color: darken(color),
                        ),
                        height: screenSize.size.height / 10 * 0.2,
                        width: screenSize.size.width / 5 * this.widget.width,
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: buttons
                            ? Container(
                                width: screenSize.size.width / 5 * this.widget.width,
                                height: screenSize.size.height / 10 * (this.widget.height - 0.2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Pin button
                                    FutureBuilder(
                                        future: getSetting(widget.event.start.hashCode.toString()),
                                        initialData: false,
                                        builder: (context, snapshot) {
                                          return RaisedButton(
                                            color: Color(0xff3b3b3b),
                                            onPressed: () async {
                                              if (snapshot.data == false) {
                                                try {
                                                  await setSetting(widget.event.start.hashCode.toString(), true);
                                                  setState(() {});
                                                  await LocalNotification.scheduleNotification(widget.event.isLesson ? this.widget.event.lesson : this.widget.event);
                                                  //Get the delay between lesson and reminder
                                                  int minutes = await getIntSetting("lessonReminderDelay");
                                                  CustomDialogs.showAnyDialog(context, "yNotes vous rappelera ce cours $minutes minutes avant son commencement.");
                                                  print("Registered " + widget.event.start.hashCode.toString());
                                                } catch (e) {
                                                  print("Error while scheduling " + e.toString());
                                                }
                                              } else {
                                                print("Canceled " + widget.event.start.hashCode.toString());
                                                await setSetting(widget.event.start.hashCode.toString(), false);
                                                setState(() {});
                                                await LocalNotification.cancelNotification(widget.event.start.hashCode);
                                              }
                                            },
                                            shape: CircleBorder(),
                                            child: Container(
                                                width: screenSize.size.width / 5 * 0.7,
                                                height: screenSize.size.width / 5 * 0.7,
                                                padding: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.05),
                                                child: Icon(
                                                  MdiIcons.alarm,
                                                  color: snapshot.data ? Colors.green : Colors.white,
                                                  size: screenSize.size.width / 5 * 0.5,
                                                )),
                                          );
                                        }),
                                  ],
                                ),
                              )
                            :
                            //real content
                            Container(
                                key: ValueKey<bool>(buttons),
                                width: screenSize.size.width / 5 * this.widget.width,
                                height: screenSize.size.height / 10 * (this.widget.height - 0.2),
                                child: Container(
                                  width: screenSize.size.width / 5 * 4.2,
                                  padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.3, vertical: screenSize.size.height / 10 * 0.1),
                                  child: Wrap(
                                    spacing: screenSize.size.width / 5 * 3.2,
                                    children: [
                                      if (this.widget.event.isLesson)
                                        AutoSizeText(
                                          "${widget.event.lesson.matiere[0].toUpperCase()}${widget.event.lesson.matiere.substring(1).toLowerCase()}",
                                          style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                          minFontSize: 12,
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
                                            DateFormat.Hm().format(widget.event.start).toString() + " - " + DateFormat.Hm().format(widget.event.end).toString(),
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
                                  ),
                                )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
