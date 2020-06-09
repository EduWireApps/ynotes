import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../usefulMethods.dart';
import '../appsPage.dart';

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
      color: Theme.of(context).backgroundColor,
      child: Center(child: Stack(
   
        children: <Widget>[
          Positioned(
            left: screenSize.size.width / 5 * 0.2,
            top: screenSize.size.height / 10 * 0.1,
            child: Material(
              borderRadius: BorderRadius.circular(11),
              color: Theme.of(context).primaryColor,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/homePage');
                  initialRoute = '/homePage';
                },
                child: Container(
                  height: screenSize.size.height / 10 * 0.5,
                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                  child: Row(
                    children: <Widget>[
                      Icon(MdiIcons.arrowLeft,  color: isDarkModeEnabled
                                      ? Colors.white
                                      : Colors.black,),
                      Text("Revenir aux applications",
                          style: TextStyle(fontFamily: "Asap", fontSize: 15,  color: isDarkModeEnabled
                                      ? Colors.white
                                      : Colors.black,)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        
          Align(
             alignment: Alignment.center,
                      child: Container(
             
              height: screenSize.size.height/10*7,
              width: screenSize.size.width/5*4.8,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                              child: ListView.builder(
                     itemCount: 5
                    ,itemBuilder: (context,index)
                  {
                 
                  }),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

