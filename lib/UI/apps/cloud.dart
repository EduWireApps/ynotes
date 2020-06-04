import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../usefulMethods.dart';

class CloudPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CloudPageState();
  }
}

class _CloudPageState extends State<CloudPage> {
  void initState() {}

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      width: screenSize.size.width,
      height: screenSize.size.height,
      child: Center(child: ListView.builder(itemBuilder: (context,index)
      {

      })),
    );
  }
}

//List of apps with "Name of app", icon, route
