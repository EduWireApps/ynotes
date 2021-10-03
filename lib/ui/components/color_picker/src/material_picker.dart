/// Material Color Picker

library material_colorpicker;

import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/color_picker/src/utils.dart';

class MaterialPicker extends StatefulWidget {
  const MaterialPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    this.enableLabel = false,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color?> onColorChanged;
  final bool enableLabel;

  @override
  State<StatefulWidget> createState() => _MaterialPickerState();
}

class _MaterialPickerState extends State<MaterialPicker> {
  final List<List<Color>> _colorTypes = [
    [Colors.red, Colors.redAccent],
    [Colors.pink, Colors.pinkAccent],
    [Colors.purple, Colors.purpleAccent],
    [Colors.deepPurple, Colors.deepPurpleAccent],
    [Colors.indigo, Colors.indigoAccent],
    [Colors.blue, Colors.blueAccent],
    [Colors.lightBlue, Colors.lightBlueAccent],
    [Colors.cyan, Colors.cyanAccent],
    [Colors.teal, Colors.tealAccent],
    [Colors.green, Colors.greenAccent],
    [Colors.lightGreen, Colors.lightGreenAccent],
    [Colors.lime, Colors.limeAccent],
    [Colors.yellow, Colors.yellowAccent],
    [Colors.amber, Colors.amberAccent],
    [Colors.orange, Colors.orangeAccent],
    [Colors.deepOrange, Colors.deepOrangeAccent],
    [Colors.brown],
    [Colors.grey],
    [Colors.blueGrey],
    [Colors.black],
  ];

  List<Color> _currentColor = [Colors.red, Colors.redAccent];
  Color? _currentShading;

  List<Color?> _shadingTypes(List<Color> colors) {
    List<Color?> result = [];

    for (var colorType in colors) {
      if (colorType == Colors.grey) {
        result.addAll([50, 100, 200, 300, 350, 400, 500, 600, 700, 800, 850, 900].map((int shade) {
          return Colors.grey[shade];
        }).toList());
      } else if (colorType == Colors.black || colorType == Colors.white) {
        result.addAll([Colors.black, Colors.white]);
      } else if (colorType is MaterialAccentColor) {
        result.addAll([100, 200, 400, 700].map((int shade) {
          return colorType[shade];
        }).toList());
      } else if (colorType is MaterialColor) {
        result.addAll([50, 100, 200, 300, 400, 500, 600, 700, 800, 900].map((int shade) {
          return colorType[shade];
        }).toList());
      } else {
        result.add(const Color(0x00000000));
      }
    }

    return result;
  }

  @override
  void initState() {
    for (var _colors in _colorTypes) {
      _shadingTypes(_colors).forEach((Color? color) {
        if (widget.pickerColor.value == color!.value) {
          return setState(() {
            _currentColor = _colors;
            _currentShading = color;
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    bool _isPortrait = _orientation == Orientation.portrait;

    Widget _colorList() {
      return Container(
        width: _isPortrait ? 60.0 : null,
        height: _isPortrait ? null : 60.0,
        decoration: BoxDecoration(
          border: _isPortrait
              ? Border(right: BorderSide(color: Colors.grey[300]!, width: 1.0))
              : Border(top: BorderSide(color: Colors.grey[300]!, width: 1.0)),
        ),
        child: ListView(
          scrollDirection: _isPortrait ? Axis.vertical : Axis.horizontal,
          children: [
            _isPortrait
                ? const Padding(padding: EdgeInsets.only(top: 7.0))
                : const Padding(padding: EdgeInsets.only(left: 7.0)),
            ..._colorTypes.map((List<Color> _colors) {
              Color _colorType = _colors[0];
              return GestureDetector(
                onTap: () => setState(() => _currentColor = _colors),
                child: Container(
                  color: const Color(0x00000000),
                  padding: _isPortrait
                      ? const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 7.0)
                      : const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                  child: Align(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 25.0,
                      height: 25.0,
                      decoration: BoxDecoration(
                        color: _colorType,
                        borderRadius: BorderRadius.circular(60.0),
                        boxShadow: _currentColor == _colors
                            ? [
                                _colorType == Theme.of(context).cardColor
                                    ? BoxShadow(
                                        color: Colors.grey[300]!,
                                        blurRadius: 5.0,
                                      )
                                    : BoxShadow(
                                        color: _colorType,
                                        blurRadius: 5.0,
                                      ),
                              ]
                            : null,
                        border: _colorType == Theme.of(context).cardColor
                            ? Border.all(color: Colors.grey[300]!, width: 1.0)
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            }),
            _isPortrait
                ? const Padding(padding: EdgeInsets.only(top: 5.0))
                : const Padding(padding: EdgeInsets.only(left: 5.0)),
          ],
        ),
      );
    }

    Widget _shadingList() {
      return ListView(
        scrollDirection: _isPortrait ? Axis.vertical : Axis.horizontal,
        children: [
          _isPortrait
              ? const Padding(padding: EdgeInsets.only(top: 15.0))
              : const Padding(padding: EdgeInsets.only(left: 15.0)),
          ..._shadingTypes(_currentColor).map((Color? _color) {
            return GestureDetector(
              onTap: () {
                setState(() => _currentShading = _color);
                widget.onColorChanged(_color);
              },
              child: Container(
                color: const Color(0x00000000),
                padding: _isPortrait
                    ? const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 7.0)
                    : const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                child: Align(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isPortrait ? 250.0 : 50.0,
                    height: _isPortrait ? 50.0 : 220.0,
                    decoration: BoxDecoration(
                      color: _color,
                      boxShadow: _currentShading == _color
                          ? [
                              _color == Theme.of(context).cardColor
                                  ? BoxShadow(
                                      color: Colors.grey[300]!,
                                      blurRadius: 5.0,
                                    )
                                  : BoxShadow(
                                      color: _color!,
                                      blurRadius: 5.0,
                                    ),
                            ]
                          : null,
                      border: _color == Theme.of(context).cardColor
                          ? Border.all(color: Colors.grey[300]!, width: 1.0)
                          : null,
                    ),
                    child: (_isPortrait && widget.enableLabel)
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '#' +
                                  (_color.toString().replaceFirst('Color(0xff', '').replaceFirst(')', ''))
                                      .toUpperCase() +
                                  '  ',
                              style: TextStyle(
                                color: useWhiteForeground(_color!) ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ),
              ),
            );
          }),
          _isPortrait
              ? const Padding(padding: EdgeInsets.only(top: 15.0))
              : const Padding(padding: EdgeInsets.only(left: 15.0)),
        ],
      );
    }

    switch (_orientation) {
      case Orientation.portrait:
        return SizedBox(
          height: 500.0,
          width: 350.0,
          child: Row(
            children: <Widget>[
              _colorList(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: _shadingList(),
                ),
              ),
            ],
          ),
        );
      case Orientation.landscape:
        return SizedBox(
          width: 500.0,
          height: 300.0,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: _shadingList(),
                ),
              ),
              _colorList(),
            ],
          ),
        );
      default:
        return Container();
    }
  }
}
