import 'package:flutter/material.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginElementBox extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const LoginElementBox({Key? key, required this.children, required this.onTap, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: YBorderRadius.xl,
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colors.backgroundLightColor,
          borderRadius: YBorderRadius.xl,
        ),
        padding: EdgeInsets.symmetric(vertical: YScale.s2, horizontal: YScale.s4),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}

/// Returns a list of vertically spaced widgets.
List<Widget> spacedChildren(List<Widget> elements) {
  List<Widget> _els = [];
  final int _length = elements.length;

  for (int i = 0; i < _length + _length - 1; i++) {
    _els.add(i % 2 == 0 ? elements[i ~/ 2] : YVerticalSpacer(YScale.s2));
  }

  return _els;
}
