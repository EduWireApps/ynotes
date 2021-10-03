import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';

class QrCrossHair extends StatelessWidget {
  const QrCrossHair({Key? key}) : super(key: key);

  final double _width = 180;
  double get _size => _width / 3;

  Widget get _emptySquare => SizedBox(
        width: _size,
        height: _size,
      );

  Widget _angle(Border border) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        border: border,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: _width,
      width: _width,
      child: Row(
        children: [
          Column(
            children: [
              _angle(Border(
                  top: BorderSide(width: 5, color: theme.colors.backgroundColor),
                  left: BorderSide(width: 5, color: theme.colors.backgroundColor))),
              _emptySquare,
              _angle(Border(
                  bottom: BorderSide(width: 5, color: theme.colors.backgroundColor),
                  left: BorderSide(width: 5, color: theme.colors.backgroundColor))),
            ],
          ),
          _emptySquare,
          Column(
            children: [
              _angle(Border(
                  top: BorderSide(width: 5, color: theme.colors.backgroundColor),
                  right: BorderSide(width: 5, color: theme.colors.backgroundColor))),
              _emptySquare,
              _angle(Border(
                  bottom: BorderSide(width: 5, color: theme.colors.backgroundColor),
                  right: BorderSide(width: 5, color: theme.colors.backgroundColor))),
            ],
          ),
        ],
      ),
    );
  }
}
