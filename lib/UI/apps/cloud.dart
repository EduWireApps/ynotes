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
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Espaces de stockages en ligne disponibles :", style: TextStyle(fontFamily: "Asap", fontSize: 15),),
          Container(
            margin: EdgeInsets.symmetric(vertical:screenSize.size.height/10*0.3, horizontal:screenSize.size.height/5*0.1 ),
            height: screenSize.size.height/10*7,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
                          child: ListView.builder(
                 itemCount: 5
                ,itemBuilder: (context,index)
              {
             
              }),
            ),
          ),
        ],
      )),
    );
  }
}

