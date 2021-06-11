import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

buildKeyValuesInfo(BuildContext context, String key, List<String?>? values) {
  if (values != null) {
    MediaQueryData screenSize = MediaQuery.of(context);
    if (values.length == 1) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Text(
                  key,
                  style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                  textAlign: TextAlign.start,
                )),
            Flexible(
              flex: 3,
              fit: FlexFit.loose,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)), color: Theme.of(context).primaryColor),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Text(
                      values[0] ?? "",
                      textAlign: TextAlign.center,
                      maxLines: 10,
                      style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              Text(key, style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor())),
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Theme.of(context).primaryColor),
                          padding: EdgeInsets.symmetric(
                              horizontal: (screenSize.size.width / 5) * 0.2,
                              vertical: (screenSize.size.width / 5) * 0.1),
                          child: FittedBox(
                            child: Text(
                              values[index]!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                            ),
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
