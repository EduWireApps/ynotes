import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/buttons.dart';

class MultipleChoicesDialog extends StatefulWidget {
  List choices;
  List<int> initialSelection;
  bool singleChoice;
  String? label;
  MultipleChoicesDialog(this.choices, this.initialSelection, {this.singleChoice = true, this.label});
  @override
  _MultipleChoicesDialogState createState() => _MultipleChoicesDialogState();
}

class _MultipleChoicesDialogState extends State<MultipleChoicesDialog> {
  List<int> indexsSelected = [];
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        contentPadding: EdgeInsets.only(top: 0.0),
        content: Container(
          padding: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
          width: screenSize.size.width / 5 * 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (this.widget.label != null)
                Container(
                  child: Text(
                    widget.label!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                  ),
                ),
              if (this.widget.label != null) Divider(),
              Container(
                height: screenSize.size.height / 10 * 3.5,
                width: screenSize.size.width / 5 * 4,
                child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                      stops: [0.0, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: ListView.builder(
                    itemCount: widget.choices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
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
                          child: Container(
                            width: screenSize.size.width / 5 * 4,
                            padding: EdgeInsets.symmetric(
                              vertical: screenSize.size.height / 10 * 0.2,
                            ),
                            child: Row(
                              children: <Widget>[
                                CircularCheckBox(
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(indexsSelected);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
                  width: screenSize.size.width / 5 * 4,
                  height: screenSize.size.height / 10 * 0.6,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2), child: buildCancelButton()),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2),
                            child: buildValidateButton()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  buildCancelButton() {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);

    return CustomButtons.materialButton(context, null, (screenSize.size.height / 10 * 8.8) / 10 * 1.2, () {
      Navigator.of(context).pop();
    }, label: "Annuler", backgroundColor: Colors.orange.shade300);
  }

  buildValidateButton() {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return CustomButtons.materialButton(context, null, (screenSize.size.height / 10 * 8.8) / 10 * 1.2, () {
      Navigator.of(context).pop(indexsSelected);
    }, label: "Valider", backgroundColor: Colors.green.shade300);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initialSelection != null && indexsSelected.isEmpty) {
      indexsSelected.addAll(widget.initialSelection);
    }
  }
}
