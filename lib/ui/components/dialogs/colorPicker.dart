import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/color_picker/flutter_colorpicker.dart';

class CustomColorPicker extends StatefulWidget {
  final Color? defaultColor;

  const CustomColorPicker({Key? key, this.defaultColor}) : super(key: key);
  @override
  _CustomColorPickerState createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  Color? pickerColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Container(
        //padding: EdgeInsets.all(screenSize.size.height/100),

        child: SingleChildScrollView(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: BlockPicker(
              pickerColor: pickerColor ?? widget.defaultColor,
              onColorChanged: changeColor,
              availableColors: [
                Colors.white,
                Color(0xfffb6b1d),
                Color(0xffe83b3b),
                Color(0xffc32454),
                Color(0xfff04f78),
                Color(0xfff68181),
                Color(0xfffca790),
                Color(0xffe3c896),
                Color(0xffab947a),
                Color(0xff966c6c),
                Color(0xff625565),
                Color(0xff1295a1),
                Color(0xff0b8a8f),
                Color(0xff1ebc73),
                Color(0xff91db69),
                Color(0xfffbff86),
                Color(0xfffbb954),
                Color(0xffcd683d),
                Color(0xff9e4539),
                Color(0xff933953),
                Color(0xff6b3e75),
                Color(0xff905ea9),
                Color(0xffa884f3),
                Color(0xffeaaded),
                Color(0xff8fd3ff),
                Color(0xff4d9be6),
                Color(0xff4d65b4),
                Color(0xff4d4f80),
                Color(0xff30e1b9),
                Color(0xff8ff8e2),
                Color(0xff8ac6d1),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            "Annuler",
            style: TextStyle(fontFamily: "Asap", color: Colors.red),
          ),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        TextButton(
          child: Text(
            "J'ai choisi",
            style: TextStyle(color: Colors.green, fontFamily: "Asap"),
          ),
          onPressed: () {
            print(pickerColor);
            Navigator.pop(context, pickerColor);
          },
        )
      ],
    );
  }

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }
}
