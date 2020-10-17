import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ynotes/UI/utils/themeUtils.dart';
import '../../../apiManager.dart';
import '../../../usefulMethods.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ynotes/main.dart';

import '../gradesChart.dart';




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
