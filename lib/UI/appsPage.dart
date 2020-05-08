import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../usefulMethods.dart';

class AppsPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _AppsPageState();
  }
}

class _AppsPageState extends State<AppsPage> {
  void initState() {}

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Accédez à vos applications",
            style: TextStyle(
                fontFamily: "Asap",
                color :isDarkModeEnabled? Colors.white : Colors.black,
                fontSize: screenSize.size.height / 10 * 0.4,
                fontWeight: FontWeight.w200),
            textAlign: TextAlign.center,
          ),
          SizedBox(height:  screenSize.size.height / 10 * 0.4,),
          Wrap(
            
            children: <Widget>[
              Container(
                 margin: EdgeInsets.all(
                                  screenSize.size.width / 5 * 0.1),
                child: Column(
                  children: <Widget>[
                    Material(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.circular(21),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(21),
                            onTap: () {},
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(21)),
                               
                                width: screenSize.size.width / 3,
                                height: screenSize.size.width / 3,
                                child: Center(child: Icon(MdiIcons.mail, size: screenSize.size.width / 6, color: isDarkModeEnabled? Colors.white : Colors.black,),),
                                ))),
                    //label
                    Text(
                      "Messagerie",
                      style: TextStyle(fontFamily: "Asap", color :isDarkModeEnabled? Colors.white : Colors.black ),
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.all(
                                  screenSize.size.width / 5 * 0.1),
                child: Column(
                  children: <Widget>[
                    Material(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.circular(21),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(21),
                            onTap: () {},
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(21)),
                              
                                width: screenSize.size.width / 3,
                                height: screenSize.size.width / 3,
                                child: Center(child: Icon(Icons.cloud, size: screenSize.size.width / 6, color: isDarkModeEnabled? Colors.white : Colors.black,),),
                                )
                              
                                )
                              
                                ),
                    //label
                    Text(
                      "Cloud",
                      style: TextStyle(fontFamily: "Asap", color :isDarkModeEnabled? Colors.white : Colors.black),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
