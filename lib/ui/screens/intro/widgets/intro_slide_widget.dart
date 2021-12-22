import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';

abstract class IntroSlideWidget extends StatelessWidget {
  @protected
  final YTColor color;

  @protected
  final double offset;

  const IntroSlideWidget({Key? key, required this.color, required this.offset}) : super(key: key);
}
