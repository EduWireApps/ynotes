
import 'package:flutter/material.dart';

class SpaceSwitcher extends StatefulWidget {
  @override
  _SpaceSwitcherState createState() => _SpaceSwitcherState();
}

class _SpaceSwitcherState extends State<SpaceSwitcher> {
  @override
  Widget build(BuildContext context) {
        MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      height: screenSize.size.height/10*5,
      
    );
  }
}