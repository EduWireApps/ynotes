import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';

class SummaryCard extends StatefulWidget {
  final Widget child;

  const SummaryCard({Key? key, required this.child}) : super(key: key);

  @override
  _SummaryCardState createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  @override
  Widget build(BuildContext context) {
    const double p = 16;

    return Container(
      padding: const EdgeInsets.all(p),
      decoration:
          BoxDecoration(color: theme.colors.backgroundColor, borderRadius: const BorderRadius.all(Radius.circular(p))),
      child: widget.child,
    );
  }
}
