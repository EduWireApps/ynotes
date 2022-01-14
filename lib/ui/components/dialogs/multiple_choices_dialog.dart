import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/legacy/theme_utils.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class MultipleChoicesDialog extends StatefulWidget {
  final List choices;
  final List<int> initialSelection;
  final bool singleChoice;
  final String? label;
  const MultipleChoicesDialog(this.choices, this.initialSelection, {Key? key, this.singleChoice = true, this.label})
      : super(key: key);
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
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        contentPadding: const EdgeInsets.only(top: 0.0),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
            width: screenSize.size.width / 5 * 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.label != null)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
                    child: Text(
                      widget.label!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                    ),
                  ),
                if (widget.label != null)
                  Divider(
                    color: ThemeUtils.textColor(),
                  ),
                SizedBox(
                  height: screenSize.size.height / 10 * 3.5,
                  width: screenSize.size.width / 5 * 4,
                  child: ShaderMask(
                    shaderCallback: (Rect rect) {
                      return const LinearGradient(
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
                                  Checkbox(
                                    side: const BorderSide(width: 1, color: Colors.white),
                                    fillColor: MaterialStateColor.resolveWith(ThemeUtils.getCheckBoxColor),
                                    shape: const CircleBorder(),
                                    value: indexsSelected.contains(index),
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
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: AutoSizeText(
                                        widget.choices[index].toString(),
                                        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                      ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: screenSize.size.width / 5 * 4,
                    height: screenSize.size.height / 10 * 0.6,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: YButton(
                                  onPressed: () => Navigator.pop(context), text: "Annuler", color: YColor.warning)),
                        ),
                        YHorizontalSpacer(YScale.s2),
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: YButton(
                                  onPressed: () => Navigator.pop(context, indexsSelected),
                                  text: "Valider",
                                  color: YColor.success)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    if (indexsSelected.isEmpty) {
      indexsSelected.addAll(widget.initialSelection);
    }
  }
}
