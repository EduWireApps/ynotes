import 'package:flutter/material.dart';
import 'package:ynotes/core/legacy/theme_utils.dart';

class NumberChoiceDialog extends StatefulWidget {
  final String unit;
  final bool isDouble;
  const NumberChoiceDialog(this.unit, {Key? key, this.isDouble = false}) : super(key: key);
  @override
  _NumberChoiceDialogState createState() => _NumberChoiceDialogState();
}

class _NumberChoiceDialogState extends State<NumberChoiceDialog> {
  TextEditingController textController = TextEditingController(text: "");
  dynamic value;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return AlertDialog(
      elevation: 50,
      backgroundColor: Theme.of(context).primaryColor,
      content: SizedBox(
        height: screenSize.size.height / 10 * 1.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Choisir ${widget.unit}",
              style: TextStyle(fontFamily: 'Asap', color: ThemeUtils.textColor()),
              textAlign: TextAlign.left,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SizedBox(
                width: screenSize.size.width / 5 * 4.3,
                height: screenSize.size.height / 10 * 0.8,
                child: TextFormField(
                  controller: textController,
                  keyboardType: TextInputType.numberWithOptions(decimal: widget.isDouble),
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
                      final String v = newValue.replaceAll(",", ".");
                      final double? valid = double.tryParse(v);
                      if (valid == null) {
                        if (v.isNotEmpty) {
                          textController.text = v.substring(0, v.length - 1);
                        }
                        return;
                      }
                      if (widget.isDouble) {
                        value = double.parse(v);
                      } else {
                        value = int.parse(v);
                      }
                    });
                  },
                  style: TextStyle(
                    fontFamily: 'Asap',
                    color: ThemeUtils.textColor(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('ANNULER', style: TextStyle(color: Colors.red), textScaleFactor: 1.0),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        TextButton(
          child: const Text(
            "VALIDER",
            style: TextStyle(color: Colors.green),
            textScaleFactor: 1.0,
          ),
          onPressed: () async {
            Navigator.pop(context, value);
          },
        )
      ],
    );
  }
}
