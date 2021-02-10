import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

class TextFieldChoiceDialog extends StatefulWidget {
  final String unit;
  final String defaultText;

  const TextFieldChoiceDialog(this.unit, this.defaultText);
  @override
  _TextFieldChoiceDialogState createState() => _TextFieldChoiceDialogState();
}

class _TextFieldChoiceDialogState extends State<TextFieldChoiceDialog> {
  TextEditingController textController = TextEditingController(text: "");
  String value;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          var splits = widget.defaultText.split(".");
          textController.text = widget.defaultText;
          if (splits.length > 1) {
            var withoutextension = splits.sublist(0, splits.length - 1).join("");
            String justExtension = "." + splits.last;
            textController.text = widget.defaultText;
            textController.selection = TextSelection(baseOffset: 0, extentOffset: withoutextension.length);
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return AlertDialog(
      elevation: 50,
      backgroundColor: Theme.of(context).primaryColor,
      content: Container(
        height: screenSize.size.height / 10 * 1.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                "Choisir ${widget.unit}",
                style: TextStyle(fontFamily: 'Asap', color: ThemeUtils.textColor()),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: screenSize.size.width / 5 * 4.3,
              height: screenSize.size.height / 10 * 0.8,
              child: TextFormField(
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ThemeUtils.textColor()),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ThemeUtils.textColor()),
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    value = newValue.trim();
                  });
                },
                style: TextStyle(
                  fontFamily: 'Asap',
                  color: ThemeUtils.textColor(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: const Text('ANNULER', style: TextStyle(color: Colors.red), textScaleFactor: 1.0),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        FlatButton(
          child: Text(
            "VALIDER",
            style: TextStyle(color: Colors.green),
            textScaleFactor: 1.0,
          ),
          onPressed: () {
            Navigator.pop(context, value);
          },
        )
      ],
    );
  }
}
