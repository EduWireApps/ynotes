import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';

// ignore: must_be_immutable
class RecurringEventsDialog extends StatefulWidget {
  String? scheme;
  RecurringEventsDialog(this.scheme);
  @override
  _RecurringEventsDialogState createState() => _RecurringEventsDialogState();
}

class _RecurringEventsDialogState extends State<RecurringEventsDialog> {
  String? _scheme;
  bool? enabled;

  bool? everyDay;

  late int weekType;

  List selectedDays = [];

  List weekTypes = ["Toutes les semaines", "Semaine A", "Semaine B"];
  @override
  Widget build(BuildContext context) {
    if (enabled == null && everyDay == null) {
      getParams();
    }
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        contentPadding: EdgeInsets.only(top: 0.0),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Container(
            width: screenSize.size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: screenSize.size.height / 10 * 3.2,
                  width: screenSize.size.width,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.1),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Activée',
                              style: TextStyle(
                                  fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.8), fontSize: 25),
                            ),
                            value: enabled!,
                            onChanged: (nValue) {
                              setState(() {
                                enabled = nValue;
                              });
                            }),
                        if (enabled!)
                          DropdownButton<String>(
                            value: weekTypes[weekType],
                            dropdownColor: Theme.of(context).primaryColor,
                            iconSize: 0.0,
                            style: TextStyle(fontSize: 18, fontFamily: "Asap", color: ThemeUtils.textColor()),
                            onChanged: (String? newValue) {
                              setState(() {
                                weekType = weekTypes.indexOf(newValue);
                              });
                            },
                            focusColor: Theme.of(context).primaryColor,
                            items: weekTypes.map<DropdownMenuItem<String>>((var value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 18, fontFamily: "Asap", color: ThemeUtils.textColor()),
                                ),
                              );
                            }).toList(),
                          ),
                        SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Tous les jours',
                              style: TextStyle(
                                  fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.8), fontSize: 25),
                            ),
                            value: everyDay!,
                            onChanged: enabled!
                                ? (nValue) {
                                    setState(() {
                                      everyDay = nValue;
                                    });
                                  }
                                : null),
                        if (enabled! && !everyDay!)
                          Wrap(
                            runSpacing: screenSize.size.width / 5 * 0.1,
                            children: [
                              buildDay(1, "L"),
                              buildDay(2, "M"),
                              buildDay(3, "M"),
                              buildDay(4, "J"),
                              buildDay(5, "V"),
                              buildDay(6, "S"),
                              buildDay(7, "D"),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
                CustomButtons.materialButton(context, null, screenSize.size.height / 10 * 0.5, () async {
                  if (enabled!) {
                    if (everyDay! ? true : selectedDays.isNotEmpty) {
                      var value = export();
                      Navigator.of(context).pop(value);
                    } else {
                      CustomDialogs.showAnyDialog(context, "Vous devez sélectionner au moins un jour");
                    }
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                    label: "J'ai fini",
                    backgroundColor: (everyDay! ? true : selectedDays.isNotEmpty)
                        ? Colors.green
                        : Theme.of(context).primaryColorDark,
                    padding: EdgeInsets.all(5),
                    borderRadius: BorderRadius.circular(8)),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ));
  }

  buildDay(int dayNumber, String dayName) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.1),
      child: Material(
        shape: CircleBorder(),
        color: selectedDays.contains(dayNumber) ? Colors.blue : Theme.of(context).primaryColorDark,
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: () {
            if (selectedDays.contains(dayNumber)) {
              setState(() {
                selectedDays.remove(dayNumber);
              });
            } else {
              setState(() {
                selectedDays.add(dayNumber);
              });
            }
          },
          child: Container(
            height: 50,
            width: 50,
            padding: EdgeInsets.all(5),
            child: Center(
              child: Text(
                dayName,
                style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  export() {
    String scheme = "";
    if (enabled!) {
      CustomLogger.log("DIALOGS", "(Recurring events) Week type: $weekType");
      scheme += weekType.toString();
      scheme += (everyDay! ? "1" : "0");
      for (int i = 1; i < 8; i++) {
        if (selectedDays.contains(i)) {
          scheme += "1";
        } else {
          scheme += "0";
        }
      }
    } else {
      scheme = "0";
    }
    return scheme;
  }

  getParams() {
    if (_scheme != null && _scheme != "0") {
      setState(() {
        enabled = true;
      });
      String schemeString = _scheme.toString();
      for (int i = 0; i < schemeString.runes.length; i++) {
        if (i == 0) {
          setState(() {
            weekType = int.parse(schemeString[i]);
          });
        }
        if (i == 1) {
          if (schemeString[i] == "0") {
            setState(() {
              everyDay = false;
            });
          } else {
            setState(() {
              everyDay = true;
            });
          }
        }
        if (i > 1) {
          if (schemeString[i] == "1") {
            selectedDays.add(i - 1);
            weekType = 0;
          }
        }
      }
    } else {
      setState(() {
        enabled = false;
        everyDay = false;
        weekType = 0;
      });
    }
  }

  getReverseAB() async {
    bool reverse = appSys.settings.user.agendaPage.reverseWeekNames;
    if (reverse) {
      setState(() {
        weekTypes = ["Toutes les semaines", "Semaine B", "Semaine A"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scheme = this.widget.scheme;
    getReverseAB();
  }
}
