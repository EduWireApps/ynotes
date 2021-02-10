import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../usefulMethods.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

class MultipleChoicesDialog extends StatefulWidget {
  List choices;
  List<int> initialSelection;
  bool singleChoice;
  MultipleChoicesDialog(this.choices, this.initialSelection, {this.singleChoice = true});
  @override
  _MultipleChoicesDialogState createState() => _MultipleChoicesDialogState();
}

class _MultipleChoicesDialogState extends State<MultipleChoicesDialog> {
  List<int> indexsSelected = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initialSelection != null && indexsSelected.isEmpty) {
      indexsSelected.addAll(widget.initialSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        contentPadding: EdgeInsets.only(top: 0.0),
        content: Container(
          height: screenSize.size.height / 10 * 4,
          width: screenSize.size.width / 5 * 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(indexsSelected);
                },
                child: Container(
                  width: screenSize.size.width / 5 * 4,
                  height: screenSize.size.height / 10 * 0.5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2),
                          height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75,
                          width: screenSize.size.width / 5 * 2,
                          child: Icon(MdiIcons.check, color: ThemeUtils.textColor())),
                    ],
                  ),
                ),
              ),
              Container(
                height: screenSize.size.height / 10 * 3.5,
                width: screenSize.size.width / 5 * 4,
                child: ListView.builder(
                  itemCount: widget.choices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: screenSize.size.width / 5 * 4,
                      padding: EdgeInsets.symmetric(
                        vertical: screenSize.size.height / 10 * 0.2,
                      ),
                      child: Row(
                        children: <Widget>[
                          CircularCheckBox(
                            inactiveColor: ThemeUtils.textColor(),
                            onChanged: (value) {
                              if (widget.singleChoice) {
                                indexsSelected.clear();
                                setState(() {
                                  indexsSelected.add(index);
                                });
                              } else {
                                if (indexsSelected.contains(index)) {
                                  setState(() {
                                    indexsSelected.removeWhere((element) => element == index);
                                  });
                                } else {
                                  setState(() {
                                    indexsSelected.add(index);
                                  });
                                }
                              }
                            },
                            value: indexsSelected.contains(index),
                          ),
                          Container(
                            width: screenSize.size.width / 5 * 3,
                            child: AutoSizeText(
                              widget.choices[index].toString(),
                              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
