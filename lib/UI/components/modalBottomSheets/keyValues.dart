import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../usefulMethods.dart';

buildKeyValuesInfo(BuildContext context, String key, List<String> values) {
  if (values != null) {
    MediaQueryData screenSize = MediaQuery.of(context);
    if (values.length == 1) {
      return FittedBox(
        child: Container(
          width: screenSize.size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(key ?? "", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
              Container(
                margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.2, vertical: (screenSize.size.width / 5) * 0.1),
                child: Text(
                  values[0] ?? "",
                  style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: screenSize.size.height / 10 * 0.7,
        width: screenSize.size.width,
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(key, style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
              SizedBox(
                height: screenSize.size.height / 10 * 0.05,
              ),
              Container(
                height: screenSize.size.height / 10 * 0.4,
                child: Center(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: values.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                          padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.2, vertical: (screenSize.size.width / 5) * 0.1),
                          child: Text(
                            values[index],
                            style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      );
    }
  } else {
    return Container();
  }
}
